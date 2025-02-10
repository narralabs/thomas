all: clean newapp

newapp:
	rails new blog -m template.rb --css tailwind

clean:
	rm -rf blog
