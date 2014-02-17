class JobsController < ApplicationController
    def show
        
    end
  def query
    @name=params[:id]
    @job=Job.find_by_name(@name)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @job }
    end
  end
end
