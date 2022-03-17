gem "devise"

after_bundle do
  rails_command("generate devise:install")
  rails_command("generate devise User")

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
