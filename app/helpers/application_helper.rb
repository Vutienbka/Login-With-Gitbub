module ApplicationHelper
  
  def stylesheets(*css)
    content_for(:head) { stylesheet_link_tag(*css) }
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
