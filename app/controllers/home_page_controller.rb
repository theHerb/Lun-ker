class HomePageController < ApplicationController

	def index
		  @photos = Photo.where(:home_page => true).order("rank DESC")
	end
	
end
