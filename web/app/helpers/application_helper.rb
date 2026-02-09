module ApplicationHelper
  def status_badge_class(status)
    case status.to_s
    when "completed" then "success"
    when "processing" then "warning"
    when "failed" then "danger"
    when "pending" then "secondary"
    else "info"
    end
  end

  def format_datetime(datetime_string)
    return "" if datetime_string.blank?
    Time.parse(datetime_string.to_s).strftime("%d/%m/%Y %H:%M")
  rescue ArgumentError
    datetime_string.to_s
  end
end
