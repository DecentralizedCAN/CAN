json.extract! comment, :id, :content, :discussion_id, :upvote_id, :user_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
