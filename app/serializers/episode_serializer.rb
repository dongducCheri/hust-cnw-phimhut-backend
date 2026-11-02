class EpisodeSerializer < BaseSerializer
  attributes :id, :season_number, :episode_number, :title, :duration, :video_url
end