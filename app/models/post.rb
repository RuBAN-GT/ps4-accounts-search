class Post < ApplicationRecord
  include Filterable

  belongs_to :source

  validates :source_id,
    :presence => true,
    :if => 'source.nil?'
  validates :source,
    :presence => true,
    :if => 'source_id.nil?'
  validates :source_uid, :presence => true

  default_scope do
    order :posted_at => :desc
  end
  scope :filter_source_id, -> (id) {
    where :source_id => id
  }
  scope :filter_source_type, -> (slug) {
    joins(:source).where :sources => { :main_type => slug } if slug.is_a?(String) && slug.length < 50
  }
  scope :filter_official, -> (v) {
    unless v.nil?
      v = (v == '1' || v == 'true') ? true : false
    end

    joins(:source).where(:sources => { :official => v })
  }
  scope :filter_author_name, -> (name) {
    where :author_name => name if name.is_a?(String) && name.length < 200
  }
  scope :filter_body, -> (text) {
    if text.is_a?(String) && text.length < 200 && !text.blank?
      text = text.gsub ' ', '%'

      where 'body ILIKE ?', "%#{text}%"
    end
  }
end
