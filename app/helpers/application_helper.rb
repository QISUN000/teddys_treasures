module ApplicationHelper
  # Generate flash message HTML with appropriate styling
  def custom_flash_message(type, message)
    flash_class = case type.to_sym
                  when :notice then 'alert-success'
                  when :alert then 'alert-danger'
                  when :error then 'alert-warning'
                  when :info then 'alert-info'
                  else 'alert-secondary'
                  end
                  
    content_tag(:div, class: "alert #{flash_class}") do
      content_tag(:span, icon_for_flash_type(type), class: 'me-2') + message
    end
  end
  
  # Return appropriate icon for flash message type
  def icon_for_flash_type(type)
    icon = case type.to_sym
           when :notice then '✅'
           when :alert then '❌'
           when :error then '⚠️'
           when :info then 'ℹ️'
           else '📢'
           end
    
    icon
  end
  
  # Helper to display session information
  def session_info
    return unless session[:visit_count] && session[:visit_count] > 1
    
    content_tag(:div, class: 'bg-light p-2 rounded mb-3') do
      content_tag(:small, class: 'text-muted') do
        safe_join([
          "Visit count: #{session[:visit_count]}",
          session[:last_visit] ? "Last visit: #{time_ago_in_words(session[:last_visit])} ago" : nil
        ].compact, tag.br)
      end
    end
  end
end
