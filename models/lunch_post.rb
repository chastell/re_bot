class LunchPost < FacebookPost
  def as_json
    JSON({text: post_text, attachments: [{text: extra_message, attachments: {image_url: post_photo}}]})
  end

  def is_not_updated?
    posted_at.to_date != Date.today
  end

  private

  def post_photo
    post["full_picture"]
  end

  def connection_data
    ["udziewczynrestauracja", "posts", fields: "message,full_picture,created_time"]
  end

  def post_subject_indicators
    /lunch|zapraszamy|smacznego/i
  end
end
