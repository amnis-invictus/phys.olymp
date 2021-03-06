set :application, 'phys.olymp'

set :repo_url, 'https://github.com/IKT-Team/phys.olymp.git'

set :rails_env, :production

set :default_env, { path: '$HOME/.rbenv/shims:$PATH' }

append :linked_files, '.env', 'config/master.key'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

set :deploy_to, '/home/arch-user/phys.olymp'

namespace :deploy do
  after :finishing, 'application:restart'
  after :finishing, 'nginx:reload'
  after :finishing, 'bundler:clean'
end
