class Resume < ActiveRecord::Base
  mount_uploader :resume_file, ResumeFileUploader
  #validates :name, presence: true
  validates_presence_of :resume_file
  validate :validate_resume_file_is_unique, on: [:create]
  


  private
  
    def validate_resume_file_is_unique
      if !resume_file.file.nil? and Resume.where(:resume_file => resume_file.file.original_filename).count > 0
        errors.add :resume_file, "'#{resume_file.file.original_filename}' already exists"
      end
    end
end
