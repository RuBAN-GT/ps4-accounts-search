class PostSerializer < ActiveModel::Serializer
  belongs_to :source

  attributes :id,
    :body,
    :author_name,
    :author_url,
    :url,
    :source_uid,
    :posted_at,
    :source_id,
    :created_at,
    :updated_at

  class SourceSerializer < ActiveModel::Serializer
    attributes :id, :url, :official, :main_type, :name
  end
end
