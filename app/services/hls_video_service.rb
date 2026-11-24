require "digest"
require "fileutils"
# Chuyển .mp4 sáng HLS 
# Tải dữ liệu lên Cloudflare R2 
# Cập nhật link stream lên CSDL
 
class HlsVideoService
   def initialize(episode, r2_raw_key = nil, storage: R2StorageService.new, transcoder: FfmpegHlsTranscoder.new)
    @episode    = episode
    @r2_prefix  = "episodes/#{@episode.id}" # Thư mục gốc trên R2 (vd: episodes/66)
    @r2_raw_key = r2_raw_key || "#{@r2_prefix}/raw/source.mp4" # Đường dẫn key của .mp4 trên R2 để tải về cắt 
    @storage    = storage # Đối tườn R2StorageService, giao tiếp với R2, tải .mp4 về và đẩy lên /hls 
    @transcoder = transcoder # Gọi ffprobe và ffmpeg 
    @work_dir = Rails.root.join("tmp", "video_processing", "episode_#{@episode.id}") # Thư mục tmp trên máy
    @raw_dir  = @work_dir.join("raw") # Thư mục con trong work_dir để chưa .mp4 từ R2 về
    @hls_dir  = @work_dir.join("hls")  # Thư mục con trong work_dir để chứa .ts từ R2 về
  end


  def call
    FileUtils.rm_rf(@work_dir)
    FileUtils.mkdir_p(@raw_dir)
    FileUtils.mkdir_p(@hls_dir)

    local_mp4_path = @storage.download_file(@r2_raw_key, @raw_dir.join("source.mp4"))

    @transcoder.transcode(local_mp4_path, @hls_dir)
    
    hls_r2_prefix = "#{@r2_prefix}/hls"
    @storage.upload_directory(@hls_dir, hls_r2_prefix)

    master_key  = "#{hls_r2_prefix}/master.m3u8"
    master_path = @hls_dir.join("master.m3u8")

    @episode.attach_hls_master!(
      master_key,
      byte_size: File.size(master_path),
      checksum: Digest::MD5.file(master_path).base64digest
    )

    { success: true, video_key: master_key, stream_url: @episode.stream_url }

  ensure 
    FileUtils.rm_rf(@work_dir) if @work_dir && Dir.exist?(@work_dir)
  end
end