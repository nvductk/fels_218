module ApplicationHelper
  def full_title page_title = ""
    base_title = t "title"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def render_404
    render file: "public/404.html", layout: false, status: 404
  end

  def active_class link_path
    current_page?(link_path) ? "active" : ""
  end

  def active_class_locale locale
    locale == I18n.locale ? "active" : ""
  end
end
