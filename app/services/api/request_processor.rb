class Api::RequestProcessor

  PROCESSOR_TYPES = %w(pictures users)

  def initialize(params)
    @version = params[:version]
    @type = params[:type]
    @action = params[:action]
    @params = params
  end

  def perform
    check_version
    check_type
    @packet_processor = packet_processor_class.new(@params)
    check_action
    @packet_processor.authenticate_user!
    @packet_processor.public_send(@action)
  rescue Api::RequestError => e
    Api::ErrorTemplate.new.info(e.message)
  end

  private
    def check_version
      raise Api::RequestError.new(1) if ALLOWED_VERSIONS.exclude?(@version)
    end

    def check_type
      raise Api::RequestError.new(2) if (@type.blank? || PROCESSOR_TYPES.exclude?(@type))
    end

    def check_action
      raise Api::RequestError.new(7) if (@action.blank? || !@packet_processor.respond_to?(@action))
    end

    def packet_processor_class
      "Api::V#{@version}::Packets::#{@type.capitalize}".constantize
    end
end
