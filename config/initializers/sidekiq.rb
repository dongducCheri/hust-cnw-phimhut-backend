redis_url = ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0")

# Cả hai server này cùng trỏ tới một redis_url 
#Server khác kết nối vào cùng địa chỉ Redis đó, thấy có việc mới trong hàng đợi thì lôi ra và gọi FFmpeg để cắt video.
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.logger.info "[Sidekiq] Server connects Redis at: #{redis_url}"
end

# Dành cho Rails Web Server Puma, nó chỉ đẩy một gói tin JSON nhỏ chứa { job: "TranscodeVideoJob", args: [episode_id] } vào Redis
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end