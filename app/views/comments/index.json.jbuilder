json.comments do
  json.array! @comments, :id, :name, :text
end
