# encoding: utf-8

namespace :statistic do
  desc 'Migrate all the Statistic Model to Metric'
  task :migrate => :environment do
    Structure.all.each do |structure|
      Metric.delay.migrate_statistics_from_structure(structure)
    end
  end
end