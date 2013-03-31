class HomePageController < ApplicationController

	def index
		  @photos = Photo.where(:home_page => true)
	end
	
end
