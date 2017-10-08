require 'csv'

namespace :import_csv do
  desc 'Seed data to Site Model'
  task :data => :environment do
    csv_text = File.read(Rails.root.join('lib', 'seeds', 'top-1m.csv'))
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      website_hash = row.to_hash
      website = Website.create!(number: website_hash['number'], url: website_hash['url'])
      website.update_attributes(website_hash)
    end
  end
end
