class ImagesController < ApplicationController

  def index
    image_path = local_image_path params[:id]
    image = File.open(image_path)
    image_data = image.read

    send_data image_data,
      :filename => params[:id],
      :type => 'image/jpeg'

  end

  def local_image_path(id)
    image_path = File.join base_images_dir, id
    if File.exists? image_path
      image_path = File.join image_path
    else
      image_path = File.join(base_images_dir, 'seeds', id)
    end
    return image_path + '.jpg'
  end

  def base_images_dir
    project_name = 'crowdpics'
    current_file = File.expand_path File.dirname __FILE__
    base_dir = current_file.split(project_name)[0]
    images_dir = File.join base_dir, project_name, 'db', 'pictures'
    return images_dir
  end

  def create
    json = ActiveSupport::JSON.decode request.raw_post

    profile = Profile.find_or_create_by_email json['email']

    photo = Photo.new
    photo.name = json['name']
    photo.hash_tag = json['hash']

    photo.lat = json['lat'].to_f unless json['lat'].nil?
    photo.long = json['long'].to_f unless json['long'].nil?
    photo.date_taken = DateTime.parse json['date_taken'] unless json['date_taken'].nil?

    if photo.save
      #todo -- call to face.com happens here
      render json: {status: :success}
    end
  end

end
