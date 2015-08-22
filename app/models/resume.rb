class Resume < ActiveRecord::Base
  mount_uploader :resume_file, ResumeFileUploader
  #validates :name, presence: true
  # validates_presence_of :resume_file
  validates :name, presence: true, length: { maximum: 25 }
  validates :phone, length: { maximum: 25 }
  validates_uniqueness_of :phone, scope: [:name]
  validate :validate_resume_file_is_unique, on: [:create]
  
  def set_commented_at
    update_attribute(:commented_at, Time.zone.now)
  end


  private
  
    def validate_resume_file_is_unique
      if !resume_file.file.nil? and Resume.where(:resume_file => resume_file.file.original_filename).count > 0
        errors.add :resume_file, "'#{resume_file.file.original_filename}' already exists"
      end
    end
end
