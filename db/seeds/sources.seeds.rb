defaults = [
  {
    :name => 'Gafuk: Официальные',
    :url => 'http://gafuk.ru/forum/thread88.html',
    :official => true,
    :main_type => 'gafuk'
  },
  {
    :name => 'Gafuk: Неофициальные',
    :url => 'http://gafuk.ru/forum/thread96.html',
    :official => false,
    :main_type => 'gafuk'
  },
  {
    :name => 'Crimsonwolf: Официальные',
    :url => 'https://crimsonwolf.ru/forum/topic/2',
    :official => true,
    :main_type => 'crimsonwolf'
  },
  {
    :name => 'Crimsonwolf: Неофициальные',
    :url => 'https://crimsonwolf.ru/forum/topic/65',
    :official => false,
    :main_type => 'crimsonwolf'
  },
  {
    :name => 'Union3',
    :url => 'https://union3.ru/topic/10',
    :official => true,
    :main_type => 'union3'
  }
]

defaults.each do |source|
  Source.new(source).save rescue nil
end

p 'Source created!'
