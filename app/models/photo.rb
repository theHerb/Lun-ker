class Photo < ActiveRecord::Base
  	attr_accessible  :name, :image, :remote_image_url, :user_id, :home_page, :rank
  	mount_uploader :image, ImageUploader
  	before_create :init

 	belongs_to :user

 	after_commit :enqueue_image, :on => :create

 	has_many :comments, as: :commentable

  	def image_name
  		File.basename(image.path || image.filename) if image
  	end

  	def enqueue_image
    	ImageWorker.perform_async(id, key) if key.present?
  	end

  	class ImageWorker
	  	include Sidekiq::Worker
		sidekiq_options retry: false
		 
		    def perform(id, key)
		      photo = Photo.find(id)
		      photo.key = key
		      photo.remote_image_url = photo.image.direct_fog_url(with_path: true)
		      photo.save!
		    end
	end

	private 
		def init
			if self.name == ""
				self.name = image_name
			end
	    end

end
