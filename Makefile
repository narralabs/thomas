SHELL := /bin/bash
.SHELLFLAGS := -o pipefail -c

all: clean newapp

newapp:
	rails new blog -m template.rb --css tailwind 2>&1 | tee generation.log
	! grep -E "version solving has failed|Could not find compatible versions|Run .*bundle install.*missing gems" generation.log

clean:
	rm -rf blog

test_output: clean newapp
	ruby test/template_output_test.rb

test_bundle: test_output
	ruby test/bundle_install_test.rb

test_ci: test_bundle
	ruby test/generated_app_test.rb
