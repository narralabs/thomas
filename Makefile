all: clean newapp

newapp:
	rails new blog -m template.rb --css tailwind

clean:
	rm -rf blog

test_output: clean newapp
	ruby test/template_output_test.rb

test_bundle:
	ruby test/bundle_install_test.rb

test_ci: test_output test_bundle
	ruby test/generated_app_test.rb
