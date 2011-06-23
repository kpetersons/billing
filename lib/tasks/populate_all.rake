namespace :db do
  desc "Fill database with sample users"
  task :populate_all => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:populate_1'].invoke
    Rake::Task['db:populate_2'].invoke
  end
end