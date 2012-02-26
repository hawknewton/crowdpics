class SearchController < ApplicationController

  def photos
    tag = params[:tag_name]
    date_time = params[:date_time]
    latitude = params[:latitude]
    longitude = params[:longitude]
    facebook_uuid = params[:facebook_uuid]
    facebook_oauth_token = params[:auth_token]

#    search = Search.new({ :facebook_uuid => facebook_uuid, :facebook_oauth_token => facebook_oauth_token, :state => 'training', :tag => tag, :latitude => latitude, :longitude => longitude, :date_time => date_time })
#    search.save

#    train(facebook_uuid, facebook_oauth_token, search.id)

#    render json: { :search_id => search.id }

    @images = get_images(nil, tag, date_time, latitude, longitude)

    puts @images.inspect
  end

  def train(facebook_uuid, facebook_oauth_token, search_id)

    domain = current_domain
    callback_url = "http://#{current_domain}/search/train_callback?search_id=#{search_id}"

    puts 'Trainng begun for search ' + search_id.to_s

    ApplicationHelper::FaceClient.train_using_facebook(facebook_uuid, facebook_oauth_token, callback_url)

  end

  def train_callback
    search = Search.find(params[:search_id])

    images = get_images search.tag, search.date_time, search.latitude, search.longitude

    puts 'Trainng complete for search ' + search_id

    search.state = 'recognizing'
    search.save

    render json: { :images => images }
  end

  def get_images(oauth_token, tag_name, date_time, latitude, longitude)
    if tag_name != nil
      images_by_tag tag_name, date_time
    elsif !latitude.nil? and !longitude.nil?
      images_by_location latitude, longitude, date_time
    else
      # For now
      Photo.all
    end
  end

  private

=begin
  def images_from_seed_data()
    seed_images_dir = File.join(ApplicationHelper::Images.base_images_dir, 'seeds')

    Dir.chdir(seed_images_dir)

    return ApplicationHelper::Images.current_images_web_paths_in_wd current_domain

  end
=end

  def images_by_tag(tag_name, date_time)
    Photo.find_all_by_hash_tag tag_name
  end

  def images_by_location(latitude, longitude, date_time)
    # Let's build us a bounding box
    #


    lat = latitude.to_f
    log = longitude.to_f

    lat_offset = 1.0 / 69.0 * 5.0
    log_offset = Math.cos(lat) * 5.0

    bottom = lat - lat_offset
    top = lat + lat_offset

    left = log - log_offset
    right = log + log_offset

    query = "MBRContains(GeomFromText('POLYGON((? ?, ? ?, ? ?, ? ?, ? ?))'), latlon) > 0"
    query_params = [
      bottom,
      left,
      bottom,
      right,
      top,
      right,
      top,
      left,
      bottom,
      left ]

    Location.where(query, *query_params).map { |x| x.photos }
  end

  def current_domain
    return request.url.split('/')[2]
  end

end
