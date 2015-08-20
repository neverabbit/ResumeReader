class Search < ActiveRecord::Base
  
  def resumes
    @resumes ||= find_resumes
  end
  
  def resumes_all
    # @resumes = Resume.last(300)
    @resumes = Resume.all
  end
  
  private
  
  def find_resumes
    resumes = Resume.order(:city)
    resumes = resumes.where("city like ?", "%#{city}%") if city.present?
    resumes = resumes.where("quality like ?", "%#{quality}%") if quality.present?
    resumes = resumes.where("education like ?", "%#{education}%") if education.present?
    resumes = resumes.where("experience like ?", "%#{experience}%") if experience.present?
    resumes = resumes.where("position like ?", "%#{position}%") if position.present?
    resumes = resumes.where("phone like ?", "%#{phone}%") if phone.present?
    resumes = resumes.where("name like ?", "%#{name}%") if name.present?
    resumes = resumes.where("period >= ?", min_period) if min_period.present?
    resumes = resumes.where("period <= ?", max_period) if max_period.present?
    resumes
  end

  
  
  
#   def find_resumes
#     Resume.find(:all, :conditions => conditions)
#   end
#
#   def city_conditions
#     ["resumes.city LIKE ?", "%#{city}%", "%#{city}%"] unless city.blank?
#   end
#
#   def quality_conditions
#     ["resumes.quality LIKE ?", "%#{quality}%", "%#{quality}%"] unless quality.blank?
#   end
#   # def education_conditions
# #     ["resumes.education"]
#
#   def conditions
#     [conditions_clauses.join(' AND '), *conditions_options]
#   end
#
#   def conditions_clauses
#     conditions_parts.map { |condition| condition.first }
#   end
#
#   def conditions_options
#     conditions_parts.map { |condition| condition[1..-1] }.flatten
#   end
#
#   def conditions_parts
#     methods.grep(/_conditions$/).map { |m| send(m) }.compact
#   end
end
