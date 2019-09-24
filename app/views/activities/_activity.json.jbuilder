json.extract! activity, :id, :title, :description, :activation, :participants, :created_at, :updated_at
json.url activity_url(activity, format: :json)
