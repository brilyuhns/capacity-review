class Capacity < ActiveRecord::Base
  validates :period_type, inclusion: { in: ['week', 'month'] }
  validates :gross_capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :planned_leaves, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :unplanned_leaves, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :source, presence: true, inclusion: { in: ['imported', 'manual'] }

  def net_capacity
    gross_capacity - planned_leaves - unplanned_leaves
  end

  def self.for_period(period_start, period_type = 'week')
    where(period_start: period_start, period_type: period_type)
  end

  def self.weekly
    where(period_type: 'week')
  end

  def self.monthly
    where(period_type: 'month')
  end
end 