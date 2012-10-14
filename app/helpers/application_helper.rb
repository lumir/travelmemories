module ApplicationHelper
  def twitterized_type(type)
    case type
      when :alert
        "alert-error"
      when :notice
        "alert-success"
      else
        type.to_s
    end
  end
end
