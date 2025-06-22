class ProjectAllocationsController < App
  get '/' do
    @project_allocations = ProjectAllocation.all
    erb :'project_allocations/index'
  end

  get '/new' do
    @project_allocation = ProjectAllocation.new
    @projects = Project.all
    erb :'project_allocations/new'
  end

  post '/' do
    @project_allocation = ProjectAllocation.new(params[:project_allocation])
    if @project_allocation.save
      redirect '/project_allocations'
    else
      @projects = Project.all
      erb :'project_allocations/new'
    end
  end

  get '/:id' do
    @project_allocation = ProjectAllocation.find(params[:id])
    erb :'project_allocations/show'
  end

  get '/:id/edit' do
    @project_allocation = ProjectAllocation.find(params[:id])
    @projects = Project.all
    erb :'project_allocations/edit'
  end

  put '/:id' do
    @project_allocation = ProjectAllocation.find(params[:id])
    if @project_allocation.update(params[:project_allocation])
      redirect '/project_allocations'
    else
      @projects = Project.all
      erb :'project_allocations/edit'
    end
  end

  delete '/:id' do
    @project_allocation = ProjectAllocation.find(params[:id])
    @project_allocation.destroy
    redirect '/project_allocations'
  end
end 