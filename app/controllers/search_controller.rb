class SearchController < ApplicationController

  def index

    oauth_token = params[:oauth_token]
    tag_name = params[:tag_name]
    date_time = params[:date_time]
    location = params[:location]

    images = get_images oauth_token, tag_name, date_time, location

    #Save search here

    train()

    render json: { :images => images }

  end

  def train

    facebook_uuid = params[:facebook_uuid]
    facebook_oauth_token = params[:oauth_token]

    domain = current_domain
    search_id = 1
    callback_url = "http://#{current_domain}/search/train_callback?search_id=#{search_id}"
    ApplicationHelper::FaceClient.train_using_facebook(facebook_uuid, facebook_oauth_token, callback_url)

  end

  def train_callback
    search_id = params[:search_id]
    puts 'Train Callback hit'
  end

  def get_images(oauth_token, tag_name, date_time, location)
    if tag_name != nil
      images = images_by_tag
    elsif location != nil
      images = images_by_location
    else
      images = images_from_seed_data
    end
  end

  @private
  def images_from_seed_data()

    seed_images_dir = File.join(ApplicationHelper::Images.base_images_dir, 'seeds')

    Dir.chdir(seed_images_dir)

    return ApplicationHelper::Images.current_images_web_paths_in_wd current_domain

  end

  def images_by_tag(tag_name, date_time)
    return []
  end

  def images_by_location(location, date_time)
    return []
  end

  def current_domain
    return request.url.split('/')[2]
  end

end
