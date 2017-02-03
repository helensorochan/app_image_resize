class Api::V1::Packets::Pictures < Api::V1::Packets::Base
  def collection
    renderer.new.render_collection(Picture.where(user_id: @user.id))
  end

  def upload
    if @params[:content_type].blank? || Picture::ALLOWED_CONTENT_TYPES.exclude?(@params[:content_type])
      raise Api::RequestError.new(10)
    end

    raise Api::RequestError.new(11) if @params[:origin_file_name].blank?
    raise Api::RequestError.new(12) if @params[:file].blank?
    raise Api::RequestError.new(13) if @params[:width].blank? || @params[:height].blank?

    picture = Picture.new(width: @params[:width],
                          height: @params[:height],
                          content_type: @params[:content_type],
                          user_id: @user.id,
                          file_name: @params[:origin_file_name])

    if picture.save
      picture.attach_file(File.binread(@params[:file]))
      renderer.new.render_upload(picture: picture)
    else
      raise Api::RequestError.new(14)
    end
  end

  def resize
    raise Api::RequestError.new(11) if @params[:file_name].blank?
    raise Api::RequestError.new(13) if @params[:width].blank? || @params[:height].blank?

    picture = Picture.where(user_id: @user.id, file_name: @params[:file_name]).first
    raise Api::RequestError.new(15) if picture.blank?

    if picture.update_attributes(width: @params[:width], height: @params[:height])
      picture.resize!
      renderer.new.render_resize(picture: picture)
    else
      raise Api::RequestError.new(16)
    end
  end
end
