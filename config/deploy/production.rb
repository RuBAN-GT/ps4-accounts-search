set :stage, :production

set :deploy_to, '/home/rVisor/Sites/ps4search/server'

role :app, %w(detemiro.org)
role :web, %w(detemiro.org)
role :db, %w(detemiro.org)

server 'detemiro.org',
  :user => 'rVisor',
  :roles => %w(app db web)

before 'passenger:restart', 'deploy:fix_permissions'
