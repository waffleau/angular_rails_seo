namespace :seo do

  desc "Generates a seo.json file"
  task :create => :environment do
    touch 'seo.json'
  end

end
