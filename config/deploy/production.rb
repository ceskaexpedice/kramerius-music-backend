set :stage, :production
set :branch, 'main'
server 'TODO', user: 'deploy', roles: %w{web app db}
