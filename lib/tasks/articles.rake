namespace :articles do
  desc "Count all articles"

  task count: :environment do
    puts "Total Articles: #{Article.count}"
  end
end