class Api::V1::Packets::Base

  NOT_REQUIRED_SESSION_ACTIONS = ['users/login']

  attr_accessor :session, :user

  def initialize(params)
    @params = params
    @route = [params[:type], params[:action]].join('/')
  end

  def authenticate_user!
    if NOT_REQUIRED_SESSION_ACTIONS.exclude?(@route)
      @session = Session.where(value: @params[:session],
                               app_version: @params[:version],
                               device: @params[:device]).last
      raise Api::RequestError.new(3) if @session.blank?
      @user = @session.user || (raise Api::RequestError.new(4))
    end
  end

  private
    def renderer
      "Api::V1::Templates::#{@params[:type].capitalize}".constantize
    end
end
