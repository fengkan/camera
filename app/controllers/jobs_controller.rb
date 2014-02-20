class JobsController < ApplicationController
    def show
        
    end
  def query
    @name=params[:id]
    @job=Job.where(name:@name)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @job, status: @job.empty??404:200 }
    end
  end
end
