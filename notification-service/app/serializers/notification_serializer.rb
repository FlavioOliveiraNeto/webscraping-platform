class NotificationSerializer
  def initialize(notification)
    @notification = notification
  end

  def as_json(_options = {})
    {
      id: @notification.id,
      event: @notification.event_type, 
      task_id: @notification.task_id,
      data: @notification.payload,   
      created_at: @notification.created_at
    }
  end
end