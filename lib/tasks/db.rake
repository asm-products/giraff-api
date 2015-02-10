namespace :db do
  desc 'Suppress activerecord logging'
  task :mute => :environment do
    ActiveRecord::Base.logger = nil
  end
end
