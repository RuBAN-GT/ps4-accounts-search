module ApplicationHelper
  def filter_value(name)
    params.permit(:filter => [name]).dig :filter, name
  end

  def source_select_tag(name, value = nil)
    options = options_from_collection_for_select Source.all.map, 'id', 'name', value

    select_tag name, options, :class => 'ui selection dropdown'
  end

  def source_type_select_tag(name, value = nil)
    options = options_for_select [
      ['Все', 0],
      ['Gafuk', 'gafuk'],
      ['Crimsonwolf', 'crimsonwolf'],
      ['Union3', 'union3']
    ], value

    select_tag name, options, :class => 'ui selection dropdown'
  end

  def official_select_tag(name, value = nil)
    options = options_for_select [
      ['Все', 0],
      ['Официальные', 'true'],
      ['Неофициальные', 'false'],
    ], value

    select_tag name, options, :class => 'ui selection dropdown'
  end
end
