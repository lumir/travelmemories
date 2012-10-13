class Users::SessionsController < Devise::SessionsController
  skip_before_filter :user_incompleted, :only => [:destroy]
end
