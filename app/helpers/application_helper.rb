module ApplicationHelper

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def stylesheets(*sass)
    content_for(:head) { stylesheet_link_tag(*sass) }
  end

  def javascripts(*js)
    content_for(:head) { javascript_include_tag(*js) }
  end

  # Breadcrumb
  def ensure_breadcrumb(title = 'ホーム', url = root_path)
    @breadcrumb ||= [{ title: title, url: url }]
  end

  def breadcrumb_add(title, url = '')
    ensure_breadcrumb << { title: title.html_safe, url: url }
  end

  def render_breadcrumb
    render partial: 'layouts/breadcrumb', locals: { ol: ensure_breadcrumb }
  end
end
