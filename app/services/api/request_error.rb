class Api::RequestError < StandardError
  def initialize(code, message = '')
    super I18n.t("request_errors.#{code}") || message
  end
end
