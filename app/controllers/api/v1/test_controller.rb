class Api::V1::TestController < ApplicationController
  def index
    render json: {
      status: "success",
      message: "Kết nối thành công từ PhimHut Rails Backend!",
      server_time: Time.current
    }
  end
end