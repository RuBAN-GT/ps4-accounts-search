module Parser
  class Crimsonwolf < Client
    ROOT  = 'https://crimsonwolf.ru'
    LOGIN = 'https://crimsonwolf.ru/accounts/login'

    def auth(login, password)
      page = manual_auth LOGIN, {
        :username => login,
        :password  => password
      }

      !page.nil? && page.uri.to_s == 'https://crimsonwolf.ru/forum/'
    end

    def parse_post_elements(page)
      page.parser.search('.posts .post__item')&.reverse
    end

    protected

    def find_last_url(page)
      part = page.parser.search('.pagination')&.first&.search('a.page')&.last&.attr('href')

      unless part.nil?
        url       = page.uri
        url.query = nil

        "#{url}#{part}"
      end
    end

    def find_next_url(page)
      url = page.parser.search('.pagination')&.first&.search('.prev a')&.attr('href')

      "#{ROOT}#{url}" unless url.nil?
    end

    def parse_element(element)
      author = element.search('.post__author')&.text

      return nil if %w(CrimsonWolf).include? author

      element.search('img').remove

      Hashie::Mash.new(
        :body => element.search('.post__body')&.last&.inner_html,
        :author_name => author,
        :author_url => "#{ROOT}#{element.search('.post__author')&.attr('href')}",
        :url => "#{ROOT}#{element.search('.permalink a')&.attr('href')}",
        :source_uid => element.attr('id')&.partition('-')&.last,
        :posted_at => element.search('.post__date')&.children&.first&.text
      )
    end
  end
end
