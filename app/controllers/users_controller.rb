class UsersController < ApplicationController
  before_action :ensure_id_exists

  def profile
    fetch_and_send_response("profile")
  end

  def subscribers
    fetch_and_send_response("subscribers")
  end

  def subscriptions
    fetch_and_send_response("subscriptions")
  end

  private

  def ensure_id_exists
    unless params[:id]
      return render json: { msg: 'Please pass in a Toyhouse profile ID!' }, status: 404
    end
  end

  def fetch_and_send_response(scraper_type)
    data = fetch_user_data(scraper_type)
    respond_with_data(data)
  end

  def fetch_user_data(scraper_type)
    user_data = SpiderManager::User.call(params[:id], scraper_type)
    user_data
  end

  def respond_with_data(user_data)
    render json: user_data, status: user_data[:status] || 200
  end
end