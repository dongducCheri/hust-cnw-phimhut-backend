require "digest"
class Episode < ApplicationRecord
  belongs_to :movie

  validates :episode_number, presence: true, numericality: { greater_than: 0 }
  validates :season_number, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true

  has_one_attached :video

  def object_key
    video.blob&.key
  end

  # trả về link HTTPS đầy đủ 
  def stream_url 
    return nil if object_key.blank?
    "#{ENV.fetch('R2_PUBLIC_URL')}/#{object_key}"
  end

  # Gắn file master.m3u8 đã upload trên R2 vào Active Storage (:video)
    def attach_hls_master!(master_key = nil, byte_size: 0, checksum: nil)
    key = master_key || "episodes/#{id}/hls/master.m3u8"

    blob = ActiveStorage::Blob.find_or_initialize_by(key: key)
    blob.update!(
      filename: "master.m3u8",
      content_type: "application/vnd.apple.mpegurl",
      byte_size: byte_size,
      checksum: checksum.presence || Digest::MD5.base64digest(key),
      service_name: ActiveStorage::Blob.service.name.to_s
    )
    # update bảng active_storage_attachments
    video.attach(blob) unless video.blob_id == blob.id
    blob
  end
end
