# Author: Anton McCook
# Symfony cache tasks
# Symfony cache tasks are run on 'web' and 'symfony' role
# global vars:
    # :release_path

namespace :symfony do
    namespace :cache do
        task :clear do
            on roles(:web, :symfony) do
                info "Running bin/console cache:clear"
                execute "cd #{release_path} && php bin/console cache:clear --env=prod --no-warmup --no-debug"
                info "Cache cleared"
            end
        end

        task :warmup do
            on roles(:web, :symfony) do
                info "Running bin/console cache:warmup"
                execute "cd #{release_path} && php bin/console cache:warmup --env=prod"
                info "Cache warmup complete"
            end
        end

        task :permissions do
            on roles(:web, :symfony) do
                info "Updating cache permissions"
                execute "sudo chown -R www-data:deploy #{release_path}/var"
                execute "sudo chmod -R 0777 #{release_path}/var"
                info "Cache permissions updated"
                Rake::Task['symfony:cache:permissions'].reenable
            end
        end

        task :set_acl do
            on roles(:web, :symfony) do
                info "Setting the ACL for the var folder"
                execute "setfacl -Rn -m u::rwX,g::rwX,o::rwX #{release_path}/var"
                info "ACL Updated"
            end
        end
    end
end
