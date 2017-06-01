class Gema::Railtie < Rails::Railtie
  rake_tasks do
    load 'gema/tasks/gema.rake'
  end
end