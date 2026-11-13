require "fileutils"
require "pathname"

class FfmpegHlsTranscoder
  DEFAULT_PROFILES = [
    { name: "360p",  width: 640,  height: 360,  video_bitrate: "800k",  audio_bitrate: "96k",  bandwidth: 896_000 },
    { name: "720p",  width: 1280, height: 720,  video_bitrate: "2500k", audio_bitrate: "128k", bandwidth: 2_628_000 },
    { name: "1080p", width: 1920, height: 1080, video_bitrate: "5000k", audio_bitrate: "192k", bandwidth: 5_192_000 }
  ].freeze

  def initialize(profiles: DEFAULT_PROFILES)
    @profiles = profiles
  end

  def transcode(input_path, output_dir)
    output_pathname = Pathname.new(output_dir)

    @profiles.each do |profile|
      transcode_profile(input_path.to_s, output_pathname, profile)
    end

    generate_master_playlist(output_pathname)
  end

  private

  def transcode_profile(input_path, output_pathname, profile)
    quality_dir = output_pathname.join(profile[:name])
    FileUtils.mkdir_p(quality_dir)

    playlist_path   = quality_dir.join("index.m3u8").to_s
    segment_pattern = quality_dir.join("segment_%04d.ts").to_s

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
      "-hls_segment_filename", segment_pattern,
      "-f", "hls",
      playlist_path
    ]

    Rails.logger.info "[HLS] Đang cắt chất lượng #{profile[:name]}..."
    success = system(*command)
    raise "FFmpeg cắt video chất lượng #{profile[:name]} thất bại!" unless success
  end

  def generate_master_playlist(output_pathname)
    lines = ["#EXTM3U", "#EXT-X-VERSION:3"]

    @profiles.each do |profile|
      lines << "#EXT-X-STREAM-INF:BANDWIDTH=#{profile[:bandwidth]},RESOLUTION=#{profile[:width]}x#{profile[:height]},NAME=\"#{profile[:name]}\""
      lines << "#{profile[:name]}/index.m3u8"
    end

    File.write(output_pathname.join("master.m3u8"), lines.join("\n") + "\n")
  end
end