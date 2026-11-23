# app/services/ffmpeg_hls_transcoder.rb
require "fileutils"
require "pathname"

class FfmpegHlsTranscoder
  ALL_PROFILES = [
    { name: "360p",  width: 640,  height: 360,  video_bitrate: "800k",  audio_bitrate: "96k",  bandwidth: 896_000 },
    { name: "720p",  width: 1280, height: 720,  video_bitrate: "2500k", audio_bitrate: "128k", bandwidth: 2_628_000 },
    { name: "1080p", width: 1920, height: 1080, video_bitrate: "5000k", audio_bitrate: "192k", bandwidth: 5_192_000 }
  ].freeze
  #width, height: Kích thước khung hình pixel, video/audio_bitrade: lượng dữ liệu truyền tải mỗi giây cho hình ảnh và âm thanh
  
  def initialize(probe_service_class: VideoProbeService)
    @probe_service_class = probe_service_class
  end

  def transcode(input_path, output_dir)
    output_pathname = Pathname.new(output_dir)
    
    # 1. Đọc thông số video gốc
    probe = @probe_service_class.new(input_path)
    source_height = probe.height
    source_codec  = probe.codec_name
    Rails.logger.info "[HLS] Video gốc: #{probe.width}x#{source_height} (codec: #{source_codec})"

    # 2. Xác định các profile sẽ tạo
    active_profiles = determine_profiles(source_height)
    highest_profile = active_profiles.max_by { |p| p[:height] }

    # 3. Tiến hành xử lý từng profile
    active_profiles.each do |profile|
      is_highest_source_match = (profile == highest_profile)

      if is_highest_source_match
        # BẢN GỐC: Cắt trực tiếp từ file gốc, không scale
        slice_original_stream(input_path.to_s, output_pathname, profile, source_codec)
      else
        # BẢN THẤP HƠN: Downscale & re-encode
        downscale_and_transcode(input_path.to_s, output_pathname, profile)
      end
    end

    # 4. Tạo master playlist chỉ chứa các profile đã tạo
    generate_master_playlist(output_pathname, active_profiles)
  end

  private

  def determine_profiles(source_height)
    profiles = ALL_PROFILES.select { |p| p[:height] <= source_height }
    profiles.empty? ? [ALL_PROFILES.min_by { |p| p[:height] }] : profiles
  end

  # Cắt trực tiếp từ file gốc mà không re-scale
  def slice_original_stream(input_path, output_pathname, profile, source_codec)
    quality_dir = output_pathname.join(profile[:name])
    FileUtils.mkdir_p(quality_dir)

    # Nếu gốc đã là h264, copy stream luôn để tốc độ cực nhanh; nếu là codec khác thì encode lại h264
    video_codec_arg = (source_codec == "h264") ? ["-c:v", "copy"] : ["-c:v", "libx264", "-crf", "22", "-preset", "veryfast"]

    command = [
      "ffmpeg", "-y",
      "-i", input_path,
      *video_codec_arg,
      "-c:a", "aac", "-b:a", profile[:audio_bitrate],
      "-start_number", "0",
      "-hls_time", "10",
      "-hls_list_size", "0",
      "-hls_segment_filename", quality_dir.join("segment_%04d.ts").to_s,
      "-f", "hls",
      quality_dir.join("index.m3u8").to_s
    ]

    Rails.logger.info "[HLS] Đang cắt trực tiếp bản gốc #{profile[:name]}..."
    run_command!(command, profile[:name])
  end

  # Downscale sang các độ phân giải thấp hơn
  def downscale_and_transcode(input_path, output_pathname, profile)
    quality_dir = output_pathname.join(profile[:name])
    FileUtils.mkdir_p(quality_dir)

    command = [
      "ffmpeg", "-y",
      "-i", input_path,
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
      "-hls_segment_filename", quality_dir.join("segment_%04d.ts").to_s,
      "-f", "hls",
      quality_dir.join("index.m3u8").to_s
    ]

    Rails.logger.info "[HLS] Đang downscale sang #{profile[:name]}..."
    run_command!(command, profile[:name])
  end

  def run_command!(command, profile_name)
    success = system(*command)
    raise "FFmpeg thất bại khi xử lý profile #{profile_name}!" unless success
  end

  def generate_master_playlist(output_pathname, active_profiles)
    lines = ["#EXTM3U", "#EXT-X-VERSION:3"]

    active_profiles.each do |profile|
      lines << "#EXT-X-STREAM-INF:BANDWIDTH=#{profile[:bandwidth]},RESOLUTION=#{profile[:width]}x#{profile[:height]},NAME=\"#{profile[:name]}\""
      lines << "#{profile[:name]}/index.m3u8"
    end

    File.write(output_pathname.join("master.m3u8"), lines.join("\n") + "\n")
  end
end