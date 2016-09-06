class FacebookPost
  attr_reader :posted_at, :post, :type, :posts

  def initialize(type, posts)
    @type = type
    @posts = posts
    @post = select_fresh_post
    @posted_at = Time.parse(@post["created_time"])
  end

  def as_json
    JSON({text: post_text, attachments: [{text: extra_message, attachments: {image_url: post_photo}}]})
  end

  def is_not_updated?
    posted_at.to_date != Date.today
  end

  private

  def select_fresh_post
    posts.select { |post| post_relevant?(post) }.first
  end

  def extra_message
    page_id, item_id = post["id"].split("_")
    "posted at: #{posted_at.to_s}\nlink: https://www.facebook.com/#{page_id}/posts/#{item_id}"
  end

  def post_text
    post["message"]
  end

  def post_photo
    post[type.class::PHOTO_KEY]
  end

  def post_relevant?(post)
    post["message"].to_s.strip.match type.post_subject_indicators
  end

  class LunchSettings
    CONNECTION_DATA = ["udziewczynrestauracja", "posts", fields: "message,full_picture,created_time"]
    PHOTO_KEY = "full_picture"

    def post_subject_indicators
      /lunch|zapraszamy|smacznego/i
    end
  end

  class WodSettings
    CONNECTION_DATA = ["CrossFitELEKTROMOC", "posts", fields: "message,picture,created_time"]
    PHOTO_KEY = "picture"

    def post_subject_indicators
      /^WOD#/
    end
  end
end
