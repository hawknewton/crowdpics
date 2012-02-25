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

end
