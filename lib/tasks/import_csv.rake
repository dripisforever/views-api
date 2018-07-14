require 'csv'
require 'smarter_csv'


namespace :import do
  desc 'Seed data to Site Model'
  task :data => :environment do
    csv_file = File.read(Rails.root.join('lib', 'seeds', 'top-200.csv'))
    csv = CSV.parse(csv_file, :headers => true)
    csv.each do |row|
      website_hash = row.to_hash
      website = Website.create!(number: website_hash['number'], url: website_hash['url'])
      website.update_attributes(website_hash)
    end
  end

  desc 'Wow'
  task :csv, [:filename] => :environment do |t, args|
    SmarterCSV.process(args[:filename], chunk_size: 10).each do |chunk|
      chunk.each do |row|
        website_hash = row.to_hash
        website = Website.create!(url: website_hash['url'])
        website.update_attributes(website_hash)
      end
    end
    # SmarterCSV.process('./seeds/top-10.csv', chunk_size: 10) do |chunk|
    #   chunk.each do |row|
    #     website_hash = row.to_hash
    #     # website = Website.create!(number: website_hash['number'], url: website_hash['url'])
    #     website = Website.create!(url: website_hash['url'])
    #     website.update_attributes(website_hash)
    #     # site = batch.sites.build(:url => row[:url])
    #   end
    # end
  end
end
