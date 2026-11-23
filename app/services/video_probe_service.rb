require "json"
require "open3"

# Chịu trách nhiệm lấy metadata của video bằng ffprobe
class VideoProbeService
  def initialize(file_path) # Đường dẫn tới video cần kiểm tra
    @file_path = file_path.to_s
  end

  def height
    video_stream["height"].to_i
  end

  def width
    video_stream["width"].to_i
  end

  def codec_name
    video_stream["codec_name"].to_s
  end

  def duration
    (video_stream["duration"] || @probe_data.dig("format", "duration")).to_f
  end

  private

  def video_stream
    @video_stream ||= begin
      raise "Lỗi: File video không tồn tại tại đường dẫn: #{@file_path}" unless File.exist?(@file_path)

      command = [
        "ffprobe", "-v", "error",
        "-select_streams", "v:0",
        "-show_entries", "stream=width,height,duration,codec_name:format=duration",
        "-of", "json", @file_path
      ]

      stdout_string, stderr_string, status = Open3.capture3(*command)
      # stdout_string: mẫu
      # {
      #   "programs": [],
      #   "streams": [
      #     {
      #       "codec_name": "av1",
      #       "width": 1920,
      #       "height": 1080,
      #       "duration": "1798.416667"
      #     }
      #   ],
      #   "format": {
      #     "duration": "1798.524807"
      #   }
      # }

      # stdout: Chuỗi JSON mà ffprobe in ra
      # stderr: Nội dung lỗi, Nếu có
      # trạng thái tiến trình
      raise "Lỗi khi chạy lệnh ffprobe: #{stderr_string}" unless status.success?

      @probe_data = JSON.parse(stdout_string)
      # @probe_data = {
      #   "programs" => [],
      #   "streams" => [
      #     {
      #       "codec_name" => "av1",
      #       "width" => 1920,
      #       "height" => 1080,
      #       "duration" => "1798.416667"
      #     }
      #   ],
      #   "format" => {
      #     "duration" => "1798.524807"
      #   }
      # }

      stream = @probe_data["streams"]&.first
      raise "Không tìm thấy luồng hình ảnh (video stream) trong file: #{@file_path}" unless stream

      stream
    end
  end
end