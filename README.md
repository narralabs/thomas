# Braces

A Rails application template with the narralabs defaults. These defaults are optimized for deployment using Docker and in AWS ECS Fargate.

## Usage

```
rails new blog -m https://raw.githubusercontent.com/westoque/braces/main/template.rb
```

## General Gems

- [Devise](https://github.com/heartcombo/devise) for authentication
- Bootstrap 5 for styling
- Simple Form for easier forms
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
