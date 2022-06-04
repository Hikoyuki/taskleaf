class ApplicationController < ActionController::Base
  def new
    @task = Task.new
  end
end
