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

  def index_for counter, page, per_page
    (page - 1) * per_page + counter + 1
  end

  def link_to_add_fields name, f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object,
      child_index: "new_#{association}") do |builder|
        render "admin/words/" + association.to_s.singularize + "_fields", f: builder
      end
    link_to_function(name, "add_fields(this, '#{association}',
      '#{escape_javascript(fields)}')",
      class: "fa fa-plus pull-right add-answer", id: "add-answer")
  end

  def link_to_remove_fields name, f
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)",
      class: "fa fa-trash fa-lg pull-right", id: "add-answer")
  end

  def link_to_function name, *args, &block
    html_options = args.extract_options!.symbolize_keys
    function = block_given? ? update_page(&block) : args[0] || ""
    onclick = "#{"#{html_options[:onclick]}; " if
        html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || "#"
    content_tag :a, name,
      html_options.merge(href: href, onclick: onclick)
  end

  def show_activities activity
      case activity.action_type
      when "follow"
        user = User.find_by id: activity.target_id
        unless user.nil?
          activity.user.name.to_s + t(".follow") + user.name
        end
      when "unfollow"
        user = User.find_by id: activity.target_id
        unless user.nil?
          activity.user.name + t(".unfollow") + user.name
        end
      when "start_lesson"
        lesson = Lesson.find_by id: activity.target_id
        unless lesson.nil?
          activity.user.name + t(".start_lesson") + lesson.category.name
        end
      when "finish_lesson"
        lesson = Lesson.find_by id: activity.target_id
        unless lesson.nil?
          activity.user.name  + t(".finish_lesson") + lesson.category.name
        end
      end
  end
end
