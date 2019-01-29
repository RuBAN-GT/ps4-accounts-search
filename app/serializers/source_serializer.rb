class SourceSerializer < ActiveModel::Serializer
  has_many :posts

  attributes :id,
    :name,
    :url,
    :official,
    :main_type
end
