require './config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end



# to use PATCH, PUT, and DELETE requests, you must tell your app to use the below sinatra middleware
use Rack::MethodOverride

use UsersController
use MadlibsController
use StoriesController

run ApplicationController
