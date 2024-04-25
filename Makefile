all: clean newapp

newapp:
	rails new -m template.rb blog

clean:
	rm -rf blog
