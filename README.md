# Braces

A Rails application template with the narralabs defaults. These defaults are optimized for deployment using Docker and in AWS ECS Fargate.

## Requirements

In order to use the rails application template, you need to have:

- At least ruby 2.7.4
- At least rails 7.0.2.3

## Usage

```
rails new blog -m https://raw.githubusercontent.com/narralabs/braces/main/template.rb
```

## General Gems

- [Devise](https://github.com/heartcombo/devise) for authentication
- Simple Form for easier forms
- Bootstrap 5 for styling
- Rollbar for error tracking
- Skylight for performance monitoring
- Delayed Job for processing background jobs
- Rack Timeout to abort requests that are taking too long
- Rubocop for static code analysis
- High Voltage for static pages
- Title for storing titles in translations

## Testing Gems

- RSpec
- FactoryBot
- Timecop
- Shoulda Matchers

## Security Gems

- [Brakeman](https://github.com/presidentbeef/brakeman) for static analysis security vulnerability scanning.
