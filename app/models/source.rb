class Source < ApplicationRecord
  has_many :posts, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true
  validates :url, :presence => true, :uniqueness => true
  validates :main_type, :presence => true
  validates :main_type, :inclusion => {
    :in => %w(gafuk crimsonwolf union3)
  }
end
