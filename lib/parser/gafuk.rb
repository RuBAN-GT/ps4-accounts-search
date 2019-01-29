module Parser
  class Gafuk < Client
    ROOT  = 'http://gafuk.ru'
    LOGIN = 'http://gafuk.ru/login'

    def auth(login, password)
      page = manual_auth LOGIN, {
        :login => login,
        :pass  => password
      }

      !page.nil? && !(page.link_with :href => /logout/).nil?
    end

    def parse_post_elements(page)
      page.parser.search('.post-table')&.reverse.each_cons(2) || []
    end

    protected

      def find_last_url(page)
        url = page.parser.search('.pagebar_pages')&.first&.search('a')&.last&.attr('href')

        "#{ROOT}#{url}" unless url.nil?
      end

      def find_next_url(page)
        links = page.parser.search('.pagebar_pages')&.first&.search('.gafuk-pagination__page')

        if !links.nil? && links.length > 1
          links.reverse.each_cons(2) do |current, link|
            if current.attributes['class']&.value&.include? 'active'
              url = link.search('a').attr('href')

              return "#{ROOT}#{url}" unless url.nil?
            end
          end
        end
      end

      def parse_element(element)
        return nil unless element.is_a? Array || element.length != 2

        meta    = element.last
        element = element.first

        return nil unless meta.attr('class') == 'post-table caption' && element.search('.post-td.avatar a')&.any?

        author = element.search('.post-td.avatar a')&.text

        return nil if %w(gafuk madalex).include? author

        element.search('img').remove

        Hashie::Mash.new(
          :body => element.search('.post-content')&.inner_html,
          :author_name => author,
          :author_url => "#{ROOT}#{element.search('.post-td.avatar a')&.attr('href')}",
          :url => "#{ROOT}#{meta.search('.post-td.date a')&.attr('href')}",
          :source_uid => meta.search('.post-td.date a')&.attr('name').text,
          :posted_at => meta.search('.post-td.date')&.children&.last&.text
        )
      end
  end
end
