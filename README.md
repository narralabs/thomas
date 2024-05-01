# Thomas

A Rails application template with the narralabs defaults. These defaults are optimized for deployment using Docker and in AWS ECS Fargate.

## Requirements

In order to use the rails application template, you need to have:

- At least ruby 2.7.4
- At least rails 7.0.2.3

## Usage

> [!IMPORTANT]
> It is recommended that you deploy immediately after creating an app using the template.  This will ensure that we do continuous deployment from the beginning of the application.

Create a new rails app using the following:

```
rails new blog -m https://raw.githubusercontent.com/narralabs/thomas/main/template.rb
```

Create a new rails app using the template with Tailwind CSS:

```
rails new blog --css tailwind -m https://raw.githubusercontent.com/narralabs/thomas/main/template.rb
```

### General Gems

- [Awesome Print](https://github.com/awesome-print/awesome_print) for beautiful puts statements
- [Devise](https://github.com/heartcombo/devise) for authentication
- [Haml](https://github.com/haml/haml-rails) for beautiful HTML markups
- [Simple Form](https://github.com/heartcombo/simple_form) for easier forms
- [SitemapGenerator](https://github.com/kjvarga/sitemap_generator) for generating sitemaps
- Delayed Job for processing background jobs
- [Rack Timeout](https://github.com/zombocom/rack-timeout) to abort requests that are taking too long
- Rubocop for static code analysis
- [High Voltage](https://github.com/thoughtbot/high_voltage) for static pages
- [Title](https://github.com/calebhearth/title) for storing titles in translations

### Testing Gems

- [RSpec](https://github.com/rspec/rspec-rails) for BDD testing
- FactoryBot
- Timecop
- Shoulda Matchers

### Security Gems

- [Brakeman](https://github.com/presidentbeef/brakeman) for static analysis security vulnerability scanning.

## Post Creation

After creating the app. It is highly recommended to:

1. Add error monitoring. We suggest rollbar.
2. Add performance monitoring. We suggest skylight.

## Developing and Contributing

To develop and contribute to the project:

1. Clone the project
2. Install dependencies: `bundle install`
3. [ADD NEW GEMS OR CONFIG HERE]
4. Run the makefile which creates the app named "blog" in the current dir: `make`
5. Check the output logs and inspect the app to see if the files and config are generated correctly
