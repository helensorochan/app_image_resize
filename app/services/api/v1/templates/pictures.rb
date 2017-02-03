class Api::V1::Templates::Pictures

  def render_collection(collection)
    collection.map{ |picture| render_picture(picture) }
  end

  def render_upload(options)
    render_picture(options[:picture])
  end

  def render_resize(options)
    render_picture(options[:picture])
  end

  private

    def render_picture(picture)
      {
        picture: {
          path: picture.file_path,
          width: picture.width,
          height: picture.height,
          name: picture.file_name
        },
        status: true
      }
    end
end
