gem "awesome_print"
gem "devise"

after_bundle do
  #run "bundle exec rails generate devise:install"
  #run "bundle exec generate devise User"

  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
