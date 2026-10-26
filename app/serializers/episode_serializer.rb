class EpisodeSerializer
  include Alba::Resource
  attributes :id, :season_number, :episode_number, :title, :duration, :video_url
end