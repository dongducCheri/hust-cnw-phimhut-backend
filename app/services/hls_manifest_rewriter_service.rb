class HlsManifestRewriterService
  def initialize(episode, storage: R2StorageService.new)
    @episode = episode
    @storage = storage
  end

  def rewrite_master(master_url)
    raw_text = @storage.get_object_body(@episode.object_key)
    result = []

    raw_text.each_line do |line|
      text = line.strip
      if text.empty? || text.start_with?("#")
        result << text
      else
        result << master_url.sub("master.m3u8", text)
      end
    end
    result.join("\n") + "\n"
  end

  def rewrite_variant(quality)
    variant_dir = "episodes/#{@episode.id}/hls/#{quality}"
    raw_text = @storage.get_object_body("#{variant_dir}/index.m3u8")
    result = []
    raw_text.each_line do |line|
      text = line.strip
      if text.empty? || text.start_with?("#")
        result << text
      else
        # text là "segment_0000.ts" -> ký Presigned URL cho đúng file trên R2
        segment_key = "#{variant_dir}/#{text}"
        result << @storage.presigned_get_url(segment_key)
      end
    end
    result.join("\n") + "\n"
  end
end
