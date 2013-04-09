class ProfilesController < ApplicationController
	before_filter :authenticate_user!, only: [:show]
	
  def show
  	@user = User.find_by_profile_name(params[:id])
  	if @user
  		@photos = Photo.where(:user_id => @user.id).page(params[:page]).per_page(16)
  		render action: :show
  	else	
  		render file: 'public/404', status: 404, formats: [:html]
  	end
  end
end