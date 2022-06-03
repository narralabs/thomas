all: clean newapp

newapp:
	bundle exec rails new -m template.rb blog

clean:
	rm -rf blog
