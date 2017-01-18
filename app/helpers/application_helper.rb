module ApplicationHelper
  def avatar_url(user, size = 500, tag_class = 'img-responsive', radius = '',
    gravity = '')
    image = retrieve_profile_image user, size
    image_tag image, width: size, height: size, class: tag_class
  end

  def date_format(date)
    if date.present?
      date.try(:strftime, "%e-%b-%Y") rescue 'N/A'
    else
      'N/A'
    end
  end

  def datetime_format(datetime)
    if datetime.present?
        datetime.try(:strftime, "%e-%b-%Y %T") rescue 'N/A'
    else
        'N/A'
    end
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def total_remaining_ammount
    number_to_currency(Donation.all.received.pluck(:amount).sum, :unit => "")
  end

  private
    def retrieve_profile_image(user, size)
      if user.avatar.present?
        user.avatar.url
      elsif user.image_url.present?
        user.image_url
      else
        gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
        "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=identicon"
      end
    end
end
