class EpisodeSerializer < BaseSerializer
  attributes :id, :season_number, :episode_number, :title, :duration

  attribute :video_url do |episode|
    episode.stream_url
  end
end