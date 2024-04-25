gem "awesome_print"
gem "devise"

gem "html2haml"
gem "haml-rails", "~> 2.0"

after_bundle do
  # Convert existing erb files to haml
  run "HAML_RAILS_DELETE_ERB=true rails haml:erb2haml"

  #run "bundle exec rails generate devise:install"
  #run "bundle exec generate devise User"

  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
