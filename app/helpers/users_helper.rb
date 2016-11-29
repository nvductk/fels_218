module UsersHelper

  def avatar_for user, options = {size: Settings.avatar_default_size}
    size = options[:size]
    avatar_path = user.avatar_path
    image_tag avatar_path, alt: user.name, class: "avatar", size: size
  end
end
