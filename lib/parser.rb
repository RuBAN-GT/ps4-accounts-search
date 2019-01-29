module Parser
  VERSION = 0.5

  class << self
    def config_path
      File.join(Rails.root, 'config', 'parser.yml')
    end

    def get_config
      data = YAML.load_file config_path

      data.nil? ? Hashie::Mash.new : Hashie::Mash.new(data)
    end

    def replace_months(date)
      months = [["января", "Jan"], ["Янв", "Jan"], ["февраля", "Feb"], ["Фев", "Feb"], ["марта", "Mar"], ["Март", "Mar"], ["апреля", "Apr"], ["Апр", "Apr"], ["мая", "May"], ["Май", "May"], ["июня", "Jun"], ["Июн", "Jun"], ["июля", "Jul"], ["Июл", "Jul"], ["августа", "Aug"], ["Авг", "Aug"], ["сентября", "Sep"], ["Сент", "Sep"], ["октября", "Oct"], ["Окт", "Oct"],  ["ноября", "Nov"], ["Ноя", "Nov"], ["декабря", "Dec"], ["Дек", "Dec"]]
      months.each do |cyrillic_month, latin_month|
        if date.match cyrillic_month
          DateTime.parse date.gsub!(/#{cyrillic_month}/, latin_month)
        end
      end

      date
    end

    def save_post(item)
      item.posted_at = item.posted_at.sub 'вчера', DateTime.yesterday.strftime('%y/%m/%d')
      item.posted_at = item.posted_at.sub 'сегодня', DateTime.now.strftime('%y/%m/%d')
      if item.posted_at.nil? || item.posted_at.include?('назад')
        item.posted_at = DateTime.now
      else
        item.posted_at = replace_months item.posted_at

        begin
          item.posted_at = DateTime.parse item.posted_at
        rescue
          item.posted_at = DateTime.now
        end

        item.posted_at = DateTime.now if item.posted_at > DateTime.now
      end

      post = Post.where(
        :source_id => item.source_id,
        :author_name => item.author_name
      )&.first

      if post.nil?
        post = Post.new(item.to_h)

        post.source_id = item.source_id
      else
        post.assign_attributes :body => item.body, :url => item.url, :posted_at => item.posted_at
      end

      post.save rescue nil
    end
  end
end
