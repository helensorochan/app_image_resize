class Api::V1::Packets::Users < Api::V1::Packets::Base

  def login
    user = User.where(login: @params[:login], password: Digest::SHA1.hexdigest(@params[:password])).first
    raise Api::RequestError.new(4) if user.blank?

    session = Session.new(user_id: user.id,
                          app_version: @params[:version],
                          device: @params[:device],
                          value: SecureRandom.hex(32))
    if session.save
      renderer.new.render_login(session: session.value)
    else
      raise Api::RequestError.new(5)
    end
  end

  def logout
    @session.destroy
    raise Api::RequestError.new(6) if @session.persisted?
    renderer.new.render_logout
  end
end
