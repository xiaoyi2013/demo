class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: [:destroy]
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  def destroy
    # current_user.microposts.find(params[:id]).destroy
    @micropost.destroy
    redirect_to root_path, notice: 'delete success'
  end

  private
  def correct_user
    # user = Micropost.find_by_id(params[:id]).user
    # redirect_to root_path, notice: 'Only the owner can delete' unless current_user?(user)
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end
end








