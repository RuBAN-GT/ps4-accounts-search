module Parser
  class Client
    ROOT = ''
    LOGIN = ''

    def initialize(login, password)
      @login    = login.to_s
      @password = password.to_s

      raise 'Wrong authentication' unless auth @login, @password
    end

    # Get http client & parser
    def agent
      return @agent unless @agent.nil?

      @agent = Mechanize.new do |agent|
        agent.user_agent = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36'
      end
    end

    # Make manual authentication with data sending
    #
    # @param [String] login_link to page with form
    # @param [Hash] data for sending to form
    def manual_auth(login_link, data = {})
      page = agent.get login_link

      page.form_with(:method => /POST/) { |f|
        data.each do |key, value|
          f.send "#{key}=", value
        end
      }.submit
    end

    # Authentication with cookies
    def auth(login, password)
      page = manual_auth self.class.LOGIN, {
        :login => login,
        :password  => password
      }

      !page.nil? && !(page.link_with :href => /logout/).nil?
    end

    # Page all pages with limit
    def parse(url, limit = 200)
      posts = []
      last  = find_last_url agent.get(url)
      url   = last unless last.nil?

      until url.nil? || limit <= 0
        page = agent.get url

        elements = parse_post_elements page
        elements.each do |element|
          post = parse_element element

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

    # Find all posts on page
    def parse_post_elements(page)
      raise 'Define me!'
    end

    protected

      # Make structure from element
      def parse_element(element)
        raise 'Define me!'
      end

      # Find next url for loop
      def find_next_url(page)
        raise 'Define me!'
      end

      # Find last page of topic
      def find_last_url(page)
        raise 'Define me!'
      end
  end
end
