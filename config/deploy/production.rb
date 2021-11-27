set :stage, :production
set :branch, 'main'
server '81.2.246.116', user: 'deploy', roles: %w{web app db}
