class Project < ActiveRecord::Base
  validates :name, presence: true
  validates :category, presence: true
  

  has_many :project_allocations

  after_initialize :set_default_category

  def self.active
    where("end_date IS NULL OR end_date >= ?", Date.today)
  end

  def self.inactive
    where("end_date < ?", Date.today)
  end

  private

  def set_default_category
    self.category ||= 'unknown'
  end
end 