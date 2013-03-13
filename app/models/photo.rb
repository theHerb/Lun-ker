class Photo < ActiveRecord::Base
  	before_create :default_name
  	attr_accessible  :name, :image, :remote_image_url, :user_id

 	belongs_to :user

  	validates :image, presence: true

  	mount_uploader :image, ImageUploader

  	def default_name
  			self.name ||= File.basename(image.filename, '.*').titleize if image
  	end

end
