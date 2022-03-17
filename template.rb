gem "devise"

after_bundle do
  rails_command("generate devise:install")
end
