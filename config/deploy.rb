lock '3.6.1'
set :application, 'kramerius-music'
set :repo_url, 'git@github.com:ceskaexpedice/kramerius-music-backend.git'
set :passenger_restart_with_touch, true
set :deploy_to, '/home/deploy/kramerius-music'
append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/application.yml'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system'
namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
