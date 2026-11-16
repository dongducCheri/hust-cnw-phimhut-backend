require "json"
require "open3"

class VideoProbeService
  def initialize(file_path)
    @file_path = file_path.to_s
    @probe_data = nil
    @video_stream = nil
    @format_data = nil
  end

  def extract_metadata
    if File.exist?(@file_path) == false
      raise "Lỗi: File video không tồn tại tại đường dẫn: #{@file_path}"
    end

    command = [
      "ffprobe",
      "-v", "error",
      "-select_streams", "v:0",
      "-show_entries", "stream=width,height,duration,codec_name:format=duration",
      "-of", "json",
      @file_path
    ]

    stdout_string, stderr_string, status = Open3.capture3(*command)

    if status.success? == false
      raise "Lỗi khi chạy lệnh ffprobe: #{stderr_string}"
    end

    @probe_data = JSON.parse(stdout_string)

    streams_list = @probe_data["streams"]
    if streams_list.nil? || streams_list.empty?
      raise "Không tìm thấy luồng hình ảnh (video stream) trong file: #{@file_path}"
    end

    @video_stream = streams_list[0]
    @format_data = @probe_data["format"]

    return true
  end

  def height
    if @video_stream.nil?
      extract_metadata
    end

    height_value = @video_stream["height"]
    return height_value.to_i
  end

  def width
    if @video_stream.nil?
      extract_metadata
    end

    width_value = @video_stream["width"]
    return width_value.to_i
  end

  def codec_name
    if @video_stream.nil?
      extract_metadata
    end

    codec_value = @video_stream["codec_name"]
    return codec_value.to_s
  end

  def duration
    if @video_stream.nil?
      extract_metadata
    end

    duration_value = @video_stream["duration"]
    if duration_value.nil? && @format_data != nil
      duration_value = @format_data["duration"]
    end

    if duration_value != nil
      return duration_value.to_f
    else
      return 0.0
    end
  end
end