# Rails Challenge

## Technical details
* Ruby/Rails: Rails 6.0.0 
* Database: `PostgreSQL 9.6+`
* Documentation: POSTMAN Documentation view here --> https://documenter.getpostman.com/view/3200410/SVmpWh5x?version=latest
* Testing:
    * rspec-rails - Testing framework.
    * factory_bot_rails - A fixtures replacement with a more straightforward syntax. 
    * shoulda_matchers - Provides RSpec with additional matchers.
    * database_cleaner - You guessed it! It literally cleans our test database to ensure a clean state in each test suite.
    * faker - A library for generating fake data. We'll use this to generate test data.

## Steps to run : 

1. bundle install
2. config/database.yml change username and use your OS username for Postgresql
3. rake db:create db:migrate
4. rails s

## start rails server
    rails s

## To run specs
    bundle exec rspec

