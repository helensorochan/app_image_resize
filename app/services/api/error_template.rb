class Api::ErrorTemplate

  def info(message)
    { error: message, status: false }
  end
end
