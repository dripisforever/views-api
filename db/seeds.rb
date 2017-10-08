# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require 'csv'

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'top-1m.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
# csv.each do |row|
#   t = Website.new
#   t.number = row['number']
#   t.url = row['url']
#   t.save
#   puts "#{t.id}, #{t.url} saved"
# end
#
# puts "There are now #{Website.count} rows in the transactions table"

CSV.foreach(Rails.root.join('lib', 'seeds', 'top-1m.csv'), headers: true) do |row|
  website_hash = row.to_hash
  website = Website.find_or_create_by!(number: website_hash['number'], url: website_hash['url'])
  website.update_attributes(website_hash)
  # puts "#{Website.number}, #{Website.url} saved"
end
