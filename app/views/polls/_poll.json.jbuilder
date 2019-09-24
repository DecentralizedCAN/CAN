json.extract! poll, :id, :answers, :solution_id, :user_id, :created_at, :updated_at
json.url poll_url(poll, format: :json)
