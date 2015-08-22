class SearchesController < ApplicationController
    
  def new
    @search = Search.new
    @resumes = @search.resumes_all.paginate(page: params[:page])
  end

  def create
    @search = Search.create!(search_params)
    redirect_to @search
  end
  
  def show
    @search = Search.find(params[:id])
    @resumes = @search.resumes.paginate(page: params[:page])
  end
  
  def update
    @search = Search.find(params[:id])
    @search.update_attributes(search_params)
    redirect_to @search
  end
  
  def refresh
    
  end
  
  private 
  def search_params
    params.require(:search).permit(:name, :quality, :education, :city, :experience, :phone, :position, :min_period, :max_period, :comment, :commented_at)
  end
  
end
