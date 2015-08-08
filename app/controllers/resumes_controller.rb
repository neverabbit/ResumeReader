class ResumesController < ApplicationController
  def home
    @resume = Resume.new
  end
end
