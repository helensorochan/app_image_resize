class Api::V1::Templates::Users

  def render_login(options)
    { session: options[:session], status: true }
  end

  def render_logout
    { status: true }
  end
end
