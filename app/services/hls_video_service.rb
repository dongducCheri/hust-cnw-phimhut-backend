require "aws-sdk-s3"
require "fileutils"
# Chuyển .mp4 sáng HLS 
# Tải dữ liệu lên Cloudflare R2 
# Cập nhật link stream lên CSDL
 
class HlsVideoService
  def initialize(episode, input_video_path)
    @episode = episode
    @input_video_path = input_video_path
    # Thư mục tạm trên máy bạn để chứa các mảnh .ts sau khi FFmpeg cắt ra
    @output_dir = Rails.root.join("tmp", "hls", "episode_#{@episode.id}")
  end

  def call
    raise "Không tìm thấy file video gốc: #{@input_video_path}" unless File.exist?(@input_video_path)

    #Tạo thư mục tạm (xoá sạch nếu lần trước còn sót lại)
    FileUtils.rm_rf(@output_dir)
    FileUtils.mkdir_p(@output_dir)

    #Gọi FFmpeg cắt file .mp4 thành master.m3u8 + các mảnh segment_000.ts, segment_001.ts...
    transcode_to_hls!

    # Upload toàn bộ các file trong thư mục tạm lên Cloudflare R2
    upload_directory_to_r2!

    #Lưu đường link Public của file master.m3u8 vào cột video_url của bảng episodes
    m3u8_public_url = "#{ENV.fetch('R2_PUBLIC_URL')}/episodes/#{@episode.id}/hls/master.m3u8"
    @episode.update!(video_url: m3u8_public_url)

    { success: true, video_url: m3u8_public_url }
  ensure
    #Luôn luôn xoá thư mục tạm trên máy sau khi chạy xong để không bị đầy ổ cứng
    FileUtils.rm_rf(@output_dir) if @output_dir && Dir.exist?(@output_dir)
  end

  private

  def transcode_to_hls!
    playlist_path = @output_dir.join("master.m3u8").to_s
    segment_pattern = @output_dir.join("segment_%04d.ts").to_s

    # Lệnh FFmpeg:
    # -c:v libx264   => Chuyển đổi sang chuẩn video H.264 tương thích 100% mọi trình duyệt
    # -c:a aac       => Chuẩn âm thanh AAC
    # -preset veryfast => Cắt và nén rất nhanh
    # -crf 22        => Đảm bảo độ nét cao
    # -hls_time 10   => Mỗi mảnh .ts dài 10 giây
    # -hls_list_size 0 => Ghi toàn bộ các mảnh vào file master.m3u8
    command = [
      "ffmpeg", "-y",
      "-i", @input_video_path.to_s,
      "-c:v", "libx264",
      "-c:a", "aac",
      "-preset", "veryfast",
      "-crf", "22",
      "-start_number", "0",
      "-hls_time", "10",
      "-hls_list_size", "0",
      "-hls_segment_filename", segment_pattern,
      "-f", "hls",
      playlist_path
    ]

    Rails.logger.info "[HLS] Đang cắt video bằng FFmpeg cho Episode ##{@episode.id}..."
    success = system(*command)
    raise "FFmpeg cắt video thất bại!" unless success
  end

  def upload_directory_to_r2!
    s3_client = Aws::S3::Client.new(
      access_key_id: ENV.fetch("R2_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("R2_SECRET_ACCESS_KEY"),
      endpoint: ENV.fetch("R2_ENDPOINT"),
      region: "auto" # Tự động phân phối vị trí lưu trữ trên toàn cầu 
    )
    bucket_name = ENV.fetch("R2_BUCKET_NAME")

    # Duyệt qua tất cả các file (.m3u8 và .ts) vừa được FFmpeg sinh ra trong thư mục tạm
    Dir.glob(@output_dir.join("*")).each do |file_path|
      filename = File.basename(file_path)
      r2_key = "episodes/#{@episode.id}/hls/#{filename}"

      # Đặt đúng Content-Type chuẩn của giao thức HLS
      content_type = filename.end_with?(".m3u8") ? "application/vnd.apple.mpegurl" : "video/mp2t"

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
end