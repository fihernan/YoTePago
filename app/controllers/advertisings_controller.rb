class AdvertisingsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :edit]

  def index
  end

  def create
  end

  def destroy
  end
end
