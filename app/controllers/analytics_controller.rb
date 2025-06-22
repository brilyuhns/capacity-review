class AnalyticsController < App
  get '/' do
    # Default to last 3 months if no dates specified
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_month - 2.months
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today.end_of_month

    # Fetch capacity data
    @capacities = Capacity.where(period_start: @start_date..@end_date)
                         .order(:period_start)

    # Format data for chart
    @capacity_data = {
      labels: @capacities.map { |c| c.period_start.strftime("%b %Y") },
      data: {
        capacityExcludingHolidays: @capacities.map(&:gross_capacity),
        netCapacity: @capacities.map(&:net_capacity),
        leaves: @capacities.map(&:planned_leaves),
        unplannedLeaves: @capacities.map(&:unplanned_leaves)
      }
    }

    # Fetch project allocation data
    @allocations = ProjectAllocation.where(period_start: @start_date..@end_date)
                                  .includes(:project)
                                  .order(:period_start)

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


    @capacity_data = {
      "labels": ["Dec", "Jan", "Feb"],
      "data": {
        "capacityExcludingHolidays": [225, 178, 200],
        "netCapacity": [168, 157.5, 182.5],
        "leaves": [57, 20.5, 17.5],
        "unplannedLeaves": [2.5, 1, 4]
      }
    }

    erb :'analytics/index'
  end
end 