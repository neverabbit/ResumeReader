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
    # @debug_info = resume_params.inspect
    unless @resume.comment.blank?
      @resume.assign_attributes({commented_at: Time.zone.now })
    end
    if params[:commit] == "新建"  
      if @resume.save
        redirect_to @resume
      else
        @debug_info = @resume.errors.full_messages
        render 'new'
      end
    elsif params[:commit] == "上传" and resume_params.include?(:resume_file)
      @resume.assign_attributes(resume_import_zhilian(@resume.resume_file.current_path))
      if @resume.save
        redirect_to @resume
      else 
        @debug_info = @resume.errors.full_messages
        render 'new'
      end
    else
      @debug_info = @resume.errors.full_messages
      render 'new'
    end
  end
  
  def show
    @resume = Resume.find(params[:id])
#     @debug_info = @resume.errors.full_messages
    if @resume.resume_file.blank?
      render 'show'
  
    else
      render 
      # redirect_to @resume.resume_file.url
    end
    # @resume = Resume.find(params[:id])
#     @debug_info = @resume.resume_file.url
  end
  
  def edit 
    @resume = Resume.find(params[:id])
  end
  
  def update
    @resume = Resume.find(params[:id])
    comment_old = @resume.comment
    if @resume.update_attributes(resume_params)
      if comment_old != @resume.comment
        @resume.set_commented_at
      end
      
      respond_to do |format|
        format.html { redirect_to @resume }
        format.js
      end
      
      # redirect_to @resume
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.js
      end
      # render 'edit'
    end
  end
  
  def admin
    @debug_info = "test" 
  end
  
  def batch_update
    resume_files = Dir.glob("#{Rails.root}/public/zhilian/**/*")
    if !resume_files.blank?
      resume_files.each do |f|
        if File.extname(f) == ".html"
          @resume = Resume.new
          @resume.resume_file = Rails.root.join(f).open
          @resume.assign_attributes(resume_import_zhilian(@resume.resume_file.current_path))
          if @resume.save
            
          else
            @debug_info = @resume.errors.full_messages
          end
        end
      end
      redirect_to new_search_path
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
        params.require(:resume).permit(:resume_file, :name, :phone, :city, :position, :education, :quality, :experience, :period, :source, :comment)
      end
#params.require(:resume).permit(:resume_file)
    end
end
