class ProjectAllocation < ActiveRecord::Base
  validates :project_id, presence: true
  validates :period_start, presence: true
  validates :period_type, presence: true, inclusion: { in: ['week', 'month'] }
  validates :allocation, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :source, presence: true, inclusion: { in: ['manual', 'imported'] }

  belongs_to :project

  def allocation_category
    project.category
  end

  # validate :period_start_within_project_dates

  private

  # def period_start_within_project_dates
  #   return if project.blank? || period_start.blank?

  #   if period_start < project.start_date
  #     errors.add(:period_start, "cannot be before project start date")
  #   end

  #   if period_start > project.end_date
  #     errors.add(:period_start, "cannot be after project end date")
  #   end
  # end
end 