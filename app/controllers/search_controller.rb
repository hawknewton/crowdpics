class SearchController < ApplicationController

  def index

    tag = params[:tag_name]
    date_time = params[:date_time]
    latitude = params[:latitude]
    longitude = params[:longitude]
    facebook_uuid = params[:facebook_uuid]
    facebook_oauth_token = params[:auth_token]

    profile = Profile.find(:facebook_profile_id => facebook_uuid)
    if profile.empty?
      profile = Profle.new({ :facebook_profile_id => facebook_uuid, :facebook_oauth_token => facebook_oauth_token })
      profile.save
    end

    search = Search.new({ :profile => profile, :state => 'training', :tag => tag, :latitude => latitude, :longitude => longitude, :date_time => date_time })
    search.save

    train(facebook_uuid, facebook_oauth_token, search.id)

    render json: { :search_id => search.id }

  end

  def train(facebook_uuid, facebook_oauth_token, search_id)

    domain = current_domain

    callback_url = "http://#{current_domain}/search/train_callback?search_id=#{search_id}"

    puts 'Training begun for search ' + search_id.to_s

    ApplicationHelper::FaceClient.train_using_facebook(facebook_uuid, facebook_oauth_token, callback_url)

  end

  def train_callback
    recognize()

    render json: { }
  end

  def recognize
    search = Search.find(params[:search_id])
    profile = search.profile

    puts 'Training complete for search ' + search_id

    images = get_images search.tag, search.date_time, search.latitude, search.date_time

    domain = current_domain

    callback_url = "http://#{current_domain}/search/recognize_callback?search_id=#{search_id}"

    ApplicationHelper::FaceClient.recognize_using_facebook profile.facebook_profile_id, profile.facebook_oauth_token, images, callback_url

    puts 'Recognition starting for search ' + search_id

    search.state = 'recognizing'
    search.save
  end

  def recognize_callback
    search = Search.find(params[:search_id])

    puts 'Recognition complete for search ' + search_id

    json = ActiveSupport::JSON.decode request.raw_post

    profile = search.profile

    json['photos'].each do |photo|

      photo_uuid = photo_url.split('images/')[1]
      photo = Photo.find(:name => photo_uuid)

      photo_tags = photo['tags']
      photo_tags.each do |photo_tag|
        best_guess_uid = photo_tag['uids'].first
        best_guess_facebook_uid = best_guess_uid.split('@')[0]
        if best_guess_facebook_uid == profile.facebook_profile_id
          tag = Tag.new(:photo => photo, :profile => profile)
          tag.save
        end
      end
    end

    search.state = 'Complete'

    search.save

    render json: { }
  end

  def get_completed_search

    search = Search.find(params[:search_id])
    if search.state != 'completed'
      render json: { :status => search.state }
    end

    profile = search.profile
    tags = Tag.find(:profile => profile)
    images = []
    tags.each do |tag|
      image_url = ApplicationHelper::Images.Images.image_web_url current_domain, tag.image.name
      images.push image_url
    end

    render json: { :status => search.state, :images => images }

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
