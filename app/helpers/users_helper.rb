module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    if user.email
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=identicon "
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    else
      image_tag('user.png', alt: user.name, class: "gravatar")
    end
  end

end