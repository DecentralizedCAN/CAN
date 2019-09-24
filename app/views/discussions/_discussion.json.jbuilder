json.extract! discussion, :id, :content, :post_id, :problem_id, :comment_id, :created_at, :updated_at
json.url discussion_url(discussion, format: :json)
