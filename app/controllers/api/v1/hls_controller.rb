class Api::V1::HlsController < Api::V1::BaseController
  before_action :set_episode

  # GET /api/v1/episodes/:id/hls/master.m3u8
  def master
    master_url = "#{request.base_url}#{request.path}"
    body = HlsManifestRewriterService.new(@episode).rewrite_master(master_url)
    render_m3u8(body)
  end

  # GET /api/v1/episodes/:id/hls/:quality/index.m3u8
  def variant
    body = HlsManifestRewriterService.new(@episode).rewrite_variant(params[:quality])
    render_m3u8(body)
  end

  private

  def set_episode
    @episode = Episode.find_by(id: params[:id])
    render json: { error: "Episode not found" }, status: :not_found unless @episode
  end

  def render_m3u8(content)
    #trả nội dung file .m3u8 về cho trình duyệt (thay vì render json)
    response.headers["Cache-Control"] = "no-store"
    # .m3u8 chứa các link .ts có hạn 5 tiếng và gắn với quyền xem hiện tại của user. Nếu trình duyệt tự ý lưu cache lại, sau 5 tiếng mở lên sẽ dùng link cũ đã hết hạn 
    render plain: content, content_type: "application/vnd.apple.mpegurl", status: :ok
  end
end