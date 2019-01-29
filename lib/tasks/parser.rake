namespace :parser do
  desc "Delete old entries"
  task :sweep => :environment do
    Post.where('created_at < ?', 1.days.ago).delete_all
  end

  desc "Parse all"
  task :all => [:environment, 'gafuk:all', 'crimsonwolf:all', 'union3:all'] do
    p 'All parsed'
  end

  namespace :gafuk do
    desc "Parse gafuk posts"
    task :all => :environment do
      data = ::Parser.get_config

      client = Parser::Gafuk.new(data&.gafuk&.login, data&.gafuk&.password)

      Source.where(:main_type => :gafuk).each do |source|
        Post.where(:source_id => source.id).delete_all

        client.parse source.url, 200 do |item|
          item.source_id = source.id

          ::Parser.save_post item
        end

        p "#{source.name} completed"
      end
    end
  end

  namespace :crimsonwolf do
    desc "Parse crimsonwolf posts"
    task :all => :environment do
      data = ::Parser.get_config

      client = Parser::Crimsonwolf.new(data&.crimsonwolf&.login, data&.crimsonwolf&.password)

      Source.where(:main_type => :crimsonwolf).each do |source|
        Post.where(:source_id => source.id).delete_all

        client.parse source.url, 150 do |item|
          item.source_id = source.id

          ::Parser.save_post item
        end

        p "#{source.name} completed"
      end
    end
  end

  namespace :union3 do
    desc "Parse union3 posts"
    task :all => :environment do
      data = ::Parser.get_config

      client = Parser::Union3.new(data&.union3&.login, data&.union3&.password)

      Source.where(:main_type => :union3).each do |source|
        Post.where(:source_id => source.id).delete_all

        client.parse source.url, 150 do |item|
          item.source_id = source.id

          ::Parser.save_post item
        end

        p "#{source.name} completed"
      end
    end
  end
end
