class TranscodeVideoJob < ApplicationJob
  queue_as :video_transcode

  def perform(episode_id, r2_raw_key = nil)
    episode = Episode.find_by(id: episode_id)
    unless episode
      Rails.logger.error "[TranscodeVideoJob] Episode with id=#{episode_id} is not found"
      return
    end
    Rails.logger.info "[TranscodeVideoJob] Start processing HLS for Episode ##{episode.id}..."
    # 2. Gọi HlsVideoService hiện có của bạn để tải file, cắt HLS và upload lên R2
    result = HlsVideoService.new(episode, r2_raw_key).call
    Rails.logger.info "[TranscodeVideoJob] Complete Episode ##{episode.id}! Link stream: #{result[:stream_url]}"
  end
end
