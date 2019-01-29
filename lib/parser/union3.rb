module Parser
  class Union3 < Client
    ROOT = 'https://union3.ru'

    def initialize(login, password)
      @login    = login.to_s
      @password = password.to_s
    end

    def parse(url, limit = 200)
      url = url.sub ROOT, "#{ROOT}/api"

      posts = []

      until url.nil? || limit <= 0
        page = agent.get url

        page = Hashie::Mash.new JSON.parse(page&.body) rescue return []

        elements = parse_post_elements page
        elements.each do |element|
          post = parse_element element, page

          next if post.nil?

          yield post if block_given?

          posts << post
          limit -= 1
          break if limit <= 0
        end

        sleep 1

        url = find_next_url page
      end

      posts
    end

    protected

      def parse_post_elements(page)
        page.posts
      end

      def find_next_url(page)
        return nil if page.pagination.currentPage == page.pagination.pageCount

        "#{ROOT}/api/#{page.url}?page=#{page.pagination.next.page}"
      end

      def parse_element(element, page)
        Hashie::Mash.new(
          :body => element.content,
          :author_name => element.user.username,
          :author_url => "#{ROOT}/user/#{element.user.userslug}",
          :url => "#{ROOT}/topic/#{page.slug}/#{element['index']}",
          :source_uid => "#{element.uid}",
          :posted_at => "#{element.timestampISO}"
        ) unless element['index'] == 0 || element.deleted == true
      end
  end
end
