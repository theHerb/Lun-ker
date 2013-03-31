class CommentsController < ApplicationController
  before_filter :load_commentable, :authenticate_user!, only: [:new, :create]
  
  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(params[:comment])
    if @comment.save
      redirect_to @commentable, notice: "Comment created."
    else
      render :new
    end
  end

private

  def load_commentable
     klass = [Status, Photo].detect { |c| params["#{c.name.underscore}_id"] }
     @commentable = klass.find(params["#{klass.name.underscore}_id"])
   end
end
