class CommentSerializer < BaseSerializer
  attributes :id, :movie_id, :content, :created_at
  attribute :user_name do |comment|
    comment.user.name
  end  
end