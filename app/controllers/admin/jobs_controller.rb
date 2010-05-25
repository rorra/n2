class Admin::JobsController < AdminController
  layout false
  def do
    begin
      jobtype = params[:job_type].camelcase.constantize
      id = params[:id]
    rescue Exception => e
      render :text => "Did not understand parameters", :status => 500 and return
    end
    
    begin
      jobtype.process(id)
      render :text => "Job successful", :status => 200 and return
    rescue Exception => e
      render :text => "Job threw an error", :status => 500 and return
    end
    
  end
end