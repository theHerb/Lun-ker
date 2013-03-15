class Photo < ActiveRecord::Base
  	attr_accessible  :name, :image, :remote_image_url, :user_id
  	mount_uploader :image, ImageUploader
  	
 	belongs_to :user

 	has_many :comments, as: :commentable

	before_create :default_name

  	def default_name
  			self.name ||= File.basename(image.filename, '.*').titleize if image
  	end

end
