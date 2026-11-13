require "aws-sdk-s3"
require "pathname"

class R2StorageService
  def initialize(
    access_key_id: ENV.fetch("R2_ACCESS_KEY_ID"),
    secret_access_key: ENV.fetch("R2_SECRET_ACCESS_KEY"),
    endpoint: ENV.fetch("R2_ENDPOINT"),
    bucket_name: ENV.fetch("R2_BUCKET_NAME")
  )
    @bucket_name = bucket_name
    @client = Aws::S3::Client.new(
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      endpoint: endpoint,
      region: "auto"
    )
  end

  def download_file(key, destination_path)
    Rails.logger.info "[R2] Đang tải video gốc từ key '#{key}' về #{destination_path}..."
    @client.get_object(
      bucket: @bucket_name,
      key: key,
      response_target: destination_path.to_s
    )
    destination_path.to_s
  rescue Aws::S3::Errors::NoSuchKey
    raise "Không tìm thấy file video gốc trên R2 tại key: #{key}"
  end

  def upload_directory(local_dir, r2_prefix)
    base_dir = Pathname.new(local_dir)

    Dir.glob(base_dir.join("**", "*")).each do |file_path|
      next unless File.file?(file_path)

      relative_path = Pathname.new(file_path).relative_path_from(base_dir).to_s
      r2_key = "#{r2_prefix}/#{relative_path}"
      content_type = file_path.end_with?(".m3u8") ? "application/vnd.apple.mpegurl" : "video/mp2t"

      File.open(file_path, "rb") do |file|
        @client.put_object(
          bucket: @bucket_name,
          key: r2_key,
          body: file,
          content_type: content_type
        )
      end
      Rails.logger.info "[R2] Đã tải lên: #{r2_key}"
    end
  end
end