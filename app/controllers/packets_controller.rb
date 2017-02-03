class PacketsController < ApplicationController
  def obtain_request
    render json: Api::RequestProcessor.new(params).perform
  end
end
