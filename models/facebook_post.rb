class FacebookPost
  attr_reader :posted_at, :response_parts, :post

  def initialize(posts)
    @posts = posts
    @post = select_fresh_post
    @posted_at = Time.parse(@post["created_time"])
  end

  private

  def select_fresh_post
    @posts.select { |post| post_relevant?(post) }.first
  end

  def extra_message
    page_id, item_id = post["id"].split("_")
    "posted at: #{posted_at.to_s}\nlink: https://www.facebook.com/#{page_id}/posts/#{item_id}"
  end

  def post_text
    post["message"]
  end

  def post_relevant?(post)
    post["message"].to_s.strip.match post_subject_indicators
  end
end
