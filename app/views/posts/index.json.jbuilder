json.posts do
  json.array! @posts, :id, :title, :text
end
