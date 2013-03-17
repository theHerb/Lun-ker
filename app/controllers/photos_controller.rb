class PhotosController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create, :update, :show, :edit, :destroy]
  
  def index
    @photos = Photo.all
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.new(params[:photo])
    if @photo.save
      flash[:notice] = "Successfully added photo."
      redirect_to photos_path
    else
      render :action => 'new'
    end

  end

  def show
    @photo = Photo.find(params[:id])
    @commentable = @photo
    @comments = @commentable.comments
    @comment = Comment.new
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = "Successfully updated photo."
      redirect_to photos_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    flash[:notice] = "Successfully destroyed photo."
    redirect_to root_path
  end
end
