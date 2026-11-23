require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  setup do
    @original_r2_public_url = ENV["R2_PUBLIC_URL"]
    ENV["R2_PUBLIC_URL"] = "https://pub-test.r2.dev/"

    @movie = Movie.create!(title: "Test Movie", movie_type: :series)
    @episode = @movie.episodes.create!(
      season_number: 1,
      episode_number: 1,
      title: "Episode 1"
    )
  end

  teardown do
    ENV["R2_PUBLIC_URL"] = @original_r2_public_url
  end

  test "stream_url returns nil when neither video nor object_key is present" do
    assert_nil @episode.stream_url
  end

  test "stream_url falls back to object_key when video is not attached" do
    @episode.update!(object_key: "episodes/66/hls/master.m3u8")

    assert_equal "https://pub-test.r2.dev/episodes/66/hls/master.m3u8", @episode.stream_url
  end

  test "attach_hls_master! attaches Active Storage blob with custom key and builds stream_url" do
    key = "episodes/#{@episode.id}/hls/master.m3u8"
    blob = @episode.attach_hls_master!(key, byte_size: 256, checksum: "abc123==")

    assert @episode.reload.video.attached?
    assert_equal blob.id, @episode.video.blob_id
    assert_equal key, @episode.video.blob.key
    assert_equal "master.m3u8", @episode.video.blob.filename.to_s
    assert_equal "application/vnd.apple.mpegurl", @episode.video.blob.content_type
    assert_equal "https://pub-test.r2.dev/#{key}", @episode.stream_url
  end

  test "attach_hls_master! is idempotent when called repeatedly for the same episode" do
    key = "episodes/#{@episode.id}/hls/master.m3u8"
    first_blob = @episode.attach_hls_master!(key, byte_size: 128)
    second_blob = @episode.attach_hls_master!(key, byte_size: 512)

    assert_equal first_blob.id, second_blob.id
    assert_equal 512, second_blob.reload.byte_size
    assert_equal 1, ActiveStorage::Blob.where(key: key).count
  end
end
