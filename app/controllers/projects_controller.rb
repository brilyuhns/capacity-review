class ProjectsController < App
  get '/' do
    logger.info "ProjectsController#index"
    @projects = Project.all
    erb :'projects/index'
  end

  get '/new' do
    @project = Project.new
    erb :'projects/new'
  end

  post '/' do
    @project = Project.new(params[:project])
    if @project.save
      redirect '/projects'
    else
      erb :'projects/new'
    end
  end

  get '/:id' do
    @project = Project.find(params[:id])
    erb :'projects/show'
  end

  get '/:id/edit' do
    @project = Project.find(params[:id])
    erb :'projects/edit'
  end

  put '/:id' do
    @project = Project.find(params[:id])
    if @project.update(params[:project])
      redirect '/projects'
    else
      erb :'projects/edit'
    end
  end

  delete '/:id' do
    @project = Project.find(params[:id])
    @project.destroy
    redirect '/projects'
  end
end 