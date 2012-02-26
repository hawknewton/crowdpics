module ApplicationHelper

  class FaceClient

    require 'rest_client'

    Face_api_train_url = 'http://api.face.com/faces/train.json'
    Face_api_recognize_url = 'http://api.face.com/faces/recognize.json'
    Api_key = 'edba69e5628551ae272d989c93c0d12f'
    Api_secret = 'a8214bc5e1b28bb6695aaa49f451dc38'
    Uids = 'friends@facebook.com'
    Namespace = 'facebook.com'

    def self.train_using_facebook(facebook_uuid, facebook_oauth_token, callback_url)

      api_info = "api_key=#{Api_key}&api_secret=#{Api_secret}"

      search_info = 'uids=friends@facebook.com&namespace=facebook.com'

      user_auth="fb_user:#{facebook_uuid},fb_oauth_token:#{facebook_oauth_token}"

      get_url = "#{Face_api_train_url}?#{api_info}&#{search_info}&user_auth=#{user_auth}&callback_url=#{callback_url}"

      puts get_url

      RestClient.get get_url
    end

    def self.recognize_using_facebook(facebook_uuid, facebook_oauth_token, image_urls, callback_url)

      api_info = "api_key=#{Api_key}&api_secret=#{Api_secret}"

      search_info = 'uids=friends@facebook.com&namespace=facebook.com'

      user_auth="fb_user:#{facebook_uuid},fb_oauth_token:#{facebook_oauth_token}"

      post_url = "#{Face_api_recognize_url}?#{api_info}&#{search_info}&user_auth=#{user_auth}&callback_url=#{callback_url}"

      formatted_image_urls = image_urls.join(',')

      RestClient.post(post_url, formatted_image_urls.to_json, :content_type => :json, :accept => :json) { |response, request, result| response }

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
