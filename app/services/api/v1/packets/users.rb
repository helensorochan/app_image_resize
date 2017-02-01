class Api::V1::Packets::Users < Api::V1::Packets::Base

  def login
    user = User.where(login: @params[:login]).first || (raise Api::RequestError.new(8))
    user = user.authenticate(@params[:password]) || (raise Api::RequestError.new(9))

    session = Session.new(user_id: user.id,
                          app_version: @params[:version],
                          device: @params[:device],
                          value: Session.generate_value)
    if session.save
      renderer.new.render_login(session: session.value)
    else
      raise Api::RequestError.new(5)
    end
  end

  def logout
    if @session.destroy
      renderer.new.render_logout
    else
      raise Api::RequestError.new(6)
    end
  end
end
