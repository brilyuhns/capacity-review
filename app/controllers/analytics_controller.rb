class AnalyticsController < App
  get '/' do
    # Default to last 3 months if no dates specified
    set_dates
    load_capacity_data
    load_allocation_data
    load_allocation_category_data

    erb :'analytics/index'
  end


  def set_dates
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_month - 2.months
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today.end_of_month
  end

  def load_capacity_data
    @capacities = Capacity.where(period_start: @start_date..@end_date)
                         .order(:period_start)
    @capacities_by_month = @capacities.group_by { |c| c.period_start.strftime("%b %Y") }
    # Format data for chart
    @capacity_data = {
      labels: @capacities_by_month.keys,
      data: {
        capacityExcludingHolidays: @capacities_by_month.map { |_, capacities| capacities.sum(&:gross_capacity) },
        netCapacity: @capacities_by_month.map { |_, capacities| capacities.sum(&:net_capacity) },
        leaves: @capacities_by_month.map { |_, capacities| capacities.sum(&:planned_leaves) },
        unplannedLeaves: @capacities_by_month.map { |_, capacities| capacities.sum(&:unplanned_leaves) }
      }
    }
  end

  def load_allocation_data
   # Fetch project allocation data
   @allocations = ProjectAllocation.where(
    period_start: @start_date..@end_date
    ).includes(:project).order(:period_start)

  # Format data for project allocation chart
    projects = Project.all
    @allocation_data = {
      labels: @allocations.map { |a| a.period_start.strftime("%b %Y") }.uniq,
      datasets: projects.map do |project|
        {
          label: project.name,
          data: @allocations.select { |a| a.project_id == project.id }
                          .map(&:allocation)
        }
      end
    }
  end

  def load_allocation_category_data
    allocation_by_category = @allocations.group_by(&:allocation_category)
    data ={}
    allocation_by_category.each do |category, allocations|
      data[category] = allocations.sum(&:allocation)
    end
    @allocation_category_data = {
      labels: allocation_by_category.keys,
      data: allocation_by_category.map do |category, allocations|
        {
          label: category,
          data: allocations.sum(&:allocation)
        }
      end
    } 
  end
end