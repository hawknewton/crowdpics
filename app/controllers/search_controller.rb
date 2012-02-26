class SearchController < ApplicationController

  def index

    tag = params[:tag_name]
    date_time = params[:date_time]
    latitude = params[:latitude]
    longitude = params[:longitude]
    facebook_uuid = params[:facebook_uuid]
    facebook_oauth_token = params[:auth_token]

    search = Search.new({ :facebook_uuid => facebook_uuid, :facebook_oauth_token => facebook_oauth_token, :state => 'training', :tag => tag, :latitude => latitude, :longitude => longitude, :date_time => date_time })
    search.save

    train(facebook_uuid, facebook_oauth_token, search.id)

    render json: { :search_id => search.id }

  end

  def train(facebook_uuid, facebook_oauth_token, search_id)

    domain = current_domain
    callback_url = "http://#{current_domain}/search/train_callback?search_id=#{search_id}"

    puts 'Trainng begun for search ' + search_id.to_s

    ApplicationHelper::FaceClient.train_using_facebook(facebook_uuid, facebook_oauth_token, callback_url)

  end

  def train_callback
    search = Search.find(params[:search_id])

    images = get_images search.tag, search.date_time, search.latitude, search.date_time

    puts 'Trainng complete for search ' + search_id

    search.state = 'recognizing'
    search.save

    render json: { :images => images }
  end

  def get_images(oauth_token, tag_name, date_time, longitude, latitude)
    if tag_name != nil
      return images_by_tag
    end

    if latitude != nill and longitude != nil
      return images_by_location
    end
    
    return images_from_seed_data
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
