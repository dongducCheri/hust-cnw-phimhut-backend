namespace :hls do
  desc "Attach existing master.m3u8 on R2 to an Episode's Active Storage :video attachment (e.g. bin/rails hls:attach_episode[66])"
  task :attach_episode, [:episode_id] => :environment do |_t, args|
    episode = Episode.find_by(id: args[:episode_id])
    abort "Episode ##{args[:episode_id]} not found" unless episode

    key = episode.object_key.presence || "episodes/#{episode.id}/hls/master.m3u8"
    blob = episode.attach_hls_master!(key)
    puts "Attached Episode ##{episode.id} -> blob key: #{blob.key} | stream_url: #{episode.stream_url}"
  end

  desc "Backfill Active Storage :video attachments for all episodes that already have an object_key"
  task backfill_attachments: :environment do
    scope = Episode.where.not(object_key: [nil, ""])
    count = 0

    scope.find_each do |episode|
      next if episode.video.attached?

      episode.attach_hls_master!(episode.object_key)
      count += 1
      puts "Attached Episode ##{episode.id} -> #{episode.stream_url}"
    end

    puts "Done. Attached #{count} episode(s)."
  end
end
