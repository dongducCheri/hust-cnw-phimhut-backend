require "fileutils"
# Chuyển .mp4 sáng HLS 
# Tải dữ liệu lên Cloudflare R2 
# Cập nhật link stream lên CSDL
 
class HlsVideoService
   def initialize(episode, r2_raw_key = nil, storage: R2StorageService.new, transcoder: FfmpegHlsTranscoder.new)
    @episode    = episode
    @r2_raw_key = r2_raw_key || "#{r2_episode_prefix}/raw/source.mp4"
    @storage    = storage
    @transcoder = transcoder
    @work_dir = Rails.root.join("tmp", "video_processing", "episode_#{@episode.id}")
    @raw_dir  = @work_dir.join("raw")
    @hls_dir  = @work_dir.join("hls")
  end

  def r2_episode_prefix 
    "movies/#{@episode.movie_id}/season_#{@episode.season_number}/episode_#{@episode.episode_number}"
  end

  def r2_hls_prefix
    "#{r2_episode_prefix}/hls"
  end

  def call
    FileUtils.rm_rf(@work_dir)
    FileUtils.mkdir_p(@raw_dir)
    FileUtils.mkdir_p(@hls_dir)

    local_mp4_path = @storage.download_file(@r2_raw_key, @raw_dir.join("source.mp4"))

    @transcoder.transcode(local_mp4_path, @hls_dir)
    @storage.upload_directory(@hls_dir, r2_hls_prefix)

    master_key = "#{r2_hls_prefix}/master.m3u8"
    @episode.update!(object_key: master_key)
    
    { success: true, video_key: master_key, stream_url: @episode.stream_url }

  ensure 
    FileUtils.rm_rf(@work_dir) if @work_dir && Dir.exist?(@work_dir)
  end
end