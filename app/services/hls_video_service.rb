require "aws-sdk-s3"
require "fileutils"
require "pathname"
# Chuyển .mp4 sáng HLS 
# Tải dữ liệu lên Cloudflare R2 
# Cập nhật link stream lên CSDL
 
class HlsVideoService
  QUALITY_PROFILES = [
    { name: "360p",  width: 640,  height: 360,  video_bitrate: "800k",  audio_bitrate: "96k",  bandwidth: 896_000 },
    { name: "720p",  width: 1280, height: 720,  video_bitrate: "2500k", audio_bitrate: "128k", bandwidth: 2_628_000 },
    { name: "1080p", width: 1920, height: 1080, video_bitrate: "5000k", audio_bitrate: "192k", bandwidth: 5_192_000 }
  ].freeze

  def initialize(episode, r2_raw_key = nil)
    @episode = episode
    @r2_raw_key = r2_raw_key || "#{r2_episode_prefix}/raw/source.mp4"

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
    local_mp4_path = download_raw_video_from_r2!
    
    transcode_to_hls!(local_mp4_path)
    generate_master_playlist!
        
    upload_directory_to_r2!

    master_key = "#{r2_hls_prefix}/master.m3u8"
    @episode.update!(video_url: master_key)
    
    { success: true, video_key: master_key, stream_url: @episode.stream_url }

  ensure 
    FileUtils.rm_rf(@work_dir) if @work_dir && Dir.exist?(@work_dir)
  end

  private
  def download_raw_video_from_r2!
    local_mp4_path = @raw_dir.join("source.mp4").to_s

    Rails.logger.info "[R2] Đang tải video gốc từ key '#{@r2_raw_key}' về #{local_mp4_path}..."
    s3_client.get_object(
      bucket: bucket_name,
      key: @r2_raw_key,
      response_target: local_mp4_path
    )
    local_mp4_path
  rescue Aws::S3::Errors::NoSuchKey
    raise "Không tìm thấy file video gốc trên R2 tại key: #{@r2_raw_key}"
  end

  def transcode_to_hls!(local_mp4_path)
    QUALITY_PROFILES.each do |profile|
      quality_dir = @hls_dir.join(profile[:name])
      FileUtils.mkdir_p(quality_dir)

      playlist_path   = quality_dir.join("index.m3u8").to_s
      segment_pattern = quality_dir.join("segment_%04d.ts").to_s

      command = [
        "ffmpeg", "-y",
        "-i", local_mp4_path,
        "-vf", "scale=-2:#{profile[:height]}",
        "-c:v", "libx264",
        "-preset", "veryfast",
        "-crf", "22",
        "-b:v", profile[:video_bitrate],
        "-c:a", "aac",
        "-b:a", profile[:audio_bitrate],
        "-start_number", "0",
        "-hls_time", "10",
        "-hls_list_size", "0",
        "-hls_segment_filename", segment_pattern,
        "-f", "hls",
        playlist_path
      ]

      Rails.logger.info "[HLS] Đang cắt chất lượng #{profile[:name]} cho Episode ##{@episode.id}..."
      success = system(*command)
      raise "FFmpeg cắt video chất lượng #{profile[:name]} thất bại!" unless success
    end
  end

  # 3. Sinh file master.m3u8 ở ngoài cùng thư mục hls/ trỏ vào 3 thư mục con (360p, 720p, 1080p)
  def generate_master_playlist!
    lines = ["#EXTM3U", "#EXT-X-VERSION:3"]

    QUALITY_PROFILES.each do |profile|
      lines << "#EXT-X-STREAM-INF:BANDWIDTH=#{profile[:bandwidth]},RESOLUTION=#{profile[:width]}x#{profile[:height]},NAME=\"#{profile[:name]}\""
      lines << "#{profile[:name]}/index.m3u8"
    end

    master_path = @hls_dir.join("master.m3u8")
    File.write(master_path, lines.join("\n") + "\n")
  end

  # 4. Duyệt đệ quy toàn bộ cây thư mục hls/ và đẩy lên R2 giữ nguyên cấu trúc thư mục con
  def upload_directory_to_r2!
    Dir.glob(@hls_dir.join("**", "*")).each do |file_path|
      next unless File.file?(file_path)

      # Lấy đường dẫn tương đối so với @hls_dir (VD: "master.m3u8", "360p/index.m3u8", "360p/segment_0000.ts")
      relative_path = Pathname.new(file_path).relative_path_from(@hls_dir).to_s
      r2_key = "#{r2_hls_prefix}/#{relative_path}"

      content_type = file_path.end_with?(".m3u8") ? "application/vnd.apple.mpegurl" : "video/mp2t"

      File.open(file_path, "rb") do |file|
        s3_client.put_object(
          bucket: bucket_name,
          key: r2_key,
          body: file,
          content_type: content_type
        )
      end
      Rails.logger.info "[R2] Đã tải lên: #{r2_key}"
    end
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(
      access_key_id: ENV.fetch("R2_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("R2_SECRET_ACCESS_KEY"),
      endpoint: ENV.fetch("R2_ENDPOINT"),
      region: "auto"
    )
  end

  def bucket_name
    @bucket_name ||= ENV.fetch("R2_BUCKET_NAME")
  end
end