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
- [Sidekiq](https://github.com/sidekiq/sidekiq) for processing background jobs
- [Rack Timeout](https://github.com/zombocom/rack-timeout) to abort requests that are taking too long
- [Rubocop](https://github.com/rubocop/rubocop) for static code analysis
- [High Voltage](https://github.com/thoughtbot/high_voltage) for static pages
- [Title](https://github.com/calebhearth/title) for storing titles in translations

### Testing Gems

- [RSpec](https://github.com/rspec/rspec-rails) for BDD testing
- [FactoryBot](https://github.com/thoughtbot/factory_bot_rails) for fixtures
- [Timecop](https://github.com/travisjeffery/timecop) for time testing
- [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for one-line matchers

### Security Gems

- [Brakeman](https://github.com/presidentbeef/brakeman) for static analysis security vulnerability scanning.

## Post Creation

After creating the app. It is highly recommended to:

1. Add error monitoring. We suggest rollbar.
2. Add performance monitoring. We suggest skylight.
3. Run devise generator: `rails generate devise:install`. The devise gem is installed but we don't make assumptions on the auth structure.

## Deployment

#### Copilot (UNDER DEVELOPMENT)

The preferred deployment setup for this template is [AWS Copilot](https://aws.github.io/copilot-cli/docs/getting-started/install/). To deploy using AWS Copilot:

1. Get your AWS Credentials and add to `~/.aws/credentials`
    ```
    [myprofile]
    aws_access_key_id=[AWS_ACCESS_KEY_ID]
    aws_secret_access_key=[AWS_SECRET_ACCESS_KEY]
    region=us-east-1
    ```

2. Use your AWS Credentials:
    ```
    export AWS_PROFILE=myprofile
    ```

3. Create the app using copilot. NOTE: You can leave the `--domain` option out but it's non-reversible.
    ```
    copilot init
    copilot env init --name production --import-vpc-id VPC_ID_HERE
    copilot env deploy --name production
    ```

4. Create the RDS managed database. Add security group.

5. Add the `SECRET_KEY_BASE` ENV variable:
    ```
    # Generate the secret key
    $ openssl rand -hex 64
    SomeLongRandomString

    $ copilot secret init
    What would you like to name this secret? [? for help] SECRET_KEY_BASE
    What is the value of secret SECRET_KEY_BASE in environment production? [? for help] SomeLongRandomString
    ```

6. Add the `POSTGRES_URL` ENV variable. Create an RDS database. Pick Postgres under the free tier plan to start.
    ```
    # Create a random db username and set aside.
    $ cat /dev/urandom | LC_ALL=C tr -dc 'a-z' | head -c 14
    RandomUsername

    # Create a random db password and set aside.
    $ openssl rand -hex 64
    RandomPassword

    # Create a random db name and set aside.
    $ cat /dev/urandom | LC_ALL=C tr -dc 'a-z' | head -c 14
    RandomDbName

    # Generate the POSTGRES_URL by concatenating the generated strings and put this aside:
    postgres://RandomUsername:RandomPassword@RDS_HOST/RandomDbName

    # Go to AWS Console RDS and create the database.
    #     - Make sure to fill up the database name field or the database will not be created.
    #     - Make sure to put the RDS database in the same subnet as the created AWS Copilot app.

    $ copilot secret init
    What would you like to name this secret? [? for help] DATABASE_URL
    What is the value of secret DATABASE_URL in environment production? [? for help] postgres://RandomUsername:RandomPassword@RDS_HOST/RandomDbName
    ```
7. Change healthcheck path to `/up`
8. Add S3 config.
9. Add Cloudfront config.


#### Heroku

1. Create an app in Heroku.
2. Get the "Heroku git URL" in the Settings->App Information tab of the app in Heroku.
3. Add the remote in the app and name it production: `git remote add production HEROKU_GIT_URL_HERE`
4. Deploy the app: `git push production master`
5. Get the URL of the app under Settings->Domains app in Heroku.
6. Add custom domain
7. Setup SSL
8. You now have a full-fledged production app


## Developing and Contributing

To develop and contribute to the project:

1. Clone the project
2. Install dependencies: `bundle install`
3. [ADD NEW GEMS OR CONFIG HERE]
4. Run the makefile which creates the app named "blog" in the current dir: `make`
5. Check the output logs and inspect the `blog` app to see if the files and config are generated correctly
