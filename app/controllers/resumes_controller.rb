class ResumesController < ApplicationController
  
  include ResumesHelper
  
  def home
    
  end
  
  def index
    @resumes = Resume.paginate(page: params[:page])
  end
  
  def new
    @resume = Resume.new
  end
  
  def create 
    # @resume = Resume.new(resume_params)
    # if resume_params.nil?
    @resume = Resume.new(resume_params)
    if @resume.save
      @resume.update_attributes(resume_import(@resume.resume_file.current_path))
      

      #File.open(resume_file)
      redirect_to @resume
    else
      @debug_info = @resume.errors.full_messages
      
      
      render 'new'
    end
  end
  
  def show
    @resume = Resume.find(params[:id])
    # @resume.update_attributes(resume_import(@resume.resume_file.current_path))
#     @debug_info = @resume.errors.full_messages
    redirect_to @resume.resume_file.url
    # @resume = Resume.find(params[:id])
#     @debug_info = @resume.resume_file.url
  end
  
  def admin
    @debug_info = "test"
    
  end
  
  def batch_update
    # @debug_info = ""
    
    resume_files = Dir.glob("#{Rails.root}/public/zhilian/智联投递简历/**/*")
    # if params[:update] == "update"
    if !resume_files.blank?
      resume_files.each do |f|
        @resume = Resume.new
        @resume.resume_file = Rails.root.join(f).open
        if @resume.save      
          @resume.update_attributes(resume_import(@resume.resume_file.current_path))
          #File.open(resume_file)
          #redirect_to @resume
        else
          @debug_info = @resume.errors.full_messages     
        end
        # resume_import(f)
      end
      redirect_to resumes_url
    end
  end
  
  def destroy
    resume = Resume.find(params[:id])
    resume.remove_resume_file!
    resume.destroy
    redirect_to new_search_path
  end
    
    
  
  
  private
    def resume_params
      if params[:resume].nil?
        return nil
      else
        params.require(:resume).permit(:resume_file)
      end
#params.require(:resume).permit(:resume_file)
    end
end
