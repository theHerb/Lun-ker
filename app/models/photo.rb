class Photo < ActiveRecord::Base
  	attr_accessible  :name, :image, :remote_image_url, :user_id
  	mount_uploader :image, ImageUploader
  	
 	belongs_to :user

 	after_save :enqueue_image

 	has_many :comments, as: :commentable

  	def image_name
  			File.basename(image.path || image.filename) if image
  	end

  	def enqueue_image
    ImageWorker.perform_async(id, key) if key.present?
  	end

	class ImageWorker
	    include Sidekiq::Worker
	    
	    def perform(id, key)
	      photo = Photo.find(id)
	      photo.key = key
	      photo.remote_image_url = photo.image.direct_fog_url(with_path: true)
	      photo.save!
	    end
	end

end
