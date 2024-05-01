gem "awesome_print", comment: "Use Awesome Print for better printing"
gem "devise", comment: "Use Devise for authentication"

gem "html2haml", comment: "Use HTML2HAML to convert erb to haml"
gem "haml-rails", "~> 2.0", comment: "Use HAML for HTML templates"

gem "sitemap_generator", comment: "Use sitemap generator to generate sitemaps"

after_bundle do
  # Convert existing erb files to haml
  run "HAML_RAILS_DELETE_ERB=true rails haml:erb2haml"

  #run "bundle exec rails generate devise:install"
  #run "bundle exec generate devise User"

  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
