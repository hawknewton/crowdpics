module ApplicationHelper

  class FaceClient

    require 'rest_client'

    Face_api_train_url = 'http://api.face.com/face/train.json'
    Api_key = '307161879343818'
    Api_secret = '39376b3b917256fdad181725a7503326'
    Uids = 'friends@facebook.com'
    Namespace = 'facebook.com'

    def self.train_using_facebook(facebook_uuid, facebook_oauth_token, callback_url)
  
      api_info = "api_key=#{Api_key}&api_secret=#{Api_secret}"

      user_auth="fb_user:#{facebook_uuid},fb_auth_token:#{facebook_oauth_token}"

      get_url = "#{Face_api_train_url}?#{api_info}&#{user_auth}&callback_url=#{callback_url}"

      puts 'URL='
      puts get_url

      RestClient.get get_url
    end

  end

  class Images

    Db_dir = 'db'
    Pictures_dir = 'pictures'
    Project_name = 'crowdpics'
    Images_controller = 'images'

    def self.current_images_web_paths_in_wd(domain)
      images = Dir.glob '*.jpg'
      images.each_index do |index|
        images[index] = image_web_url domain, images[index].split('.')[0]
      end

      return images
    end

    def self.base_images_dir
      current_file = File.expand_path File.dirname __FILE__
      base_dir = current_file.split(Project_name)[0]
      images_dir = File.join base_dir, Project_name, Db_dir, Pictures_dir
      return images_dir
    end

    def self.image_web_url(domain, image_uuid)
      return "http://#{domain}/#{Images_controller}/#{image_uuid}"
    end

  end

end
