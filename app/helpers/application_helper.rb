module ApplicationHelper
  def avatar_url(user, size = 500, tag_class = 'img-responsive', radius = '',
    gravity = '')
    image = retrieve_profile_image user, size
    image_tag image, width: size, height: size, class: tag_class
  end

  private
    def retrieve_profile_image(user, size)
      if user.image_url.present?
        user.image_url
      else
        gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
        "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=identicon"
      end
    end
end
