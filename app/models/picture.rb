class Picture

  ALLOWED_CONTENT_TYPES = ['image/png', 'image/jpeg']

  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_name, type: String
  field :content_type, type: String
  field :height, type: Integer
  field :width, type: Integer

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  validates :file_name, :content_type, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than_or_equal_to: 0 }

  def file_name=(origin_file_name)
    self[:file_name] = [Time.now.strftime("%Y%m%d%H%M%S"), origin_file_name].join
  end

  def file_path
    Rails.root.join('public', 'pictures', file_name)
  end

  def attach_file(binary_data)
    save_origin_file(binary_data)
    resize!
  end

  def save_origin_file(binary_data)
    File.open(file_path, 'wb'){|file| file.write(binary_data) }
  end

  def resize!
    image = MiniMagick::Image.open(file_path)
    image.resize "#{width}x#{height}"
    image.write Rails.root.join(file_path)
  end
end
