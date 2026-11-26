require "aws-sdk-s3"
require "pathname"

class R2StorageService
  DEFAULT_EXPIRES_IN = 18_000 # 5h
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
      region: "auto",
      force_path_style: true
    )
    @presigner = Aws::S3::Presigner.new(client: @client)
  end

  def download_file(key, destination_path)
    Rails.logger.info "[R2] Đang tải video gốc từ key '#{key}' về #{destination_path}..."
    # get_object: tải, đọc dữ liệu của một file cụ thể từ bucket 
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

      relative_path = Pathname.new(file_path).relative_path_from(base_dir).to_s # Lấy filepath - basedir =  C:/.../episode_66/hls/360p/index.m3u8 - C:/.../episode_66/hls = 360p/index.m3u8 
      r2_key = "#{r2_prefix}/#{relative_path}" # episodes/66/hls + 360p/index.m3u8
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

  def get_object_body(key)
    @client.get_object(bucket: @bucket_name, key: key).body.read.force_encoding("UTF-8")
    # .body.read trả về ASCOO-8BIT (Binary), tránh CompatibilityError khi xử lý chuỗi, chuẩn file .m3u8 sử dụng bảng mã UTF-8
  end

  def presigned_get_url(key, expires_in: DEFAULT_EXPIRES_IN)
    # key: đường dẫn file muốn tạo link trên R2
    # presigned_url: hàm có sẵn của Aws sdk, truyền vào 4 tham số như dưới, :get_object là hành động được cấp phép, đường link chỉ để xem (GET)
    @presigner.presigned_url(
      :get_object,
      bucket: @bucket_name,
      key: key,
      expires_in: expires_in
    )
  end

end