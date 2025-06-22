class CapacitiesController < App
  get '/' do
    @capacities = Capacity.all
    erb :'capacities/index'
  end

  get '/new' do
    @capacity = Capacity.new
    erb :'capacities/new'
  end

  post '/' do
    @capacity = Capacity.new(params[:capacity])
    if @capacity.save
      redirect '/capacities'
    else
      erb :'capacities/new'
    end
  end

  get '/:id' do
    @capacity = Capacity.find(params[:id])
    erb :'capacities/show'
  end

  get '/:id/edit' do
    @capacity = Capacity.find(params[:id])
    erb :'capacities/edit'
  end

  put '/:id' do
    @capacity = Capacity.find(params[:id])
    if @capacity.update(params[:capacity])
      redirect '/capacities'
    else
      erb :'capacities/edit'
    end
  end

  delete '/:id' do
    @capacity = Capacity.find(params[:id])
    @capacity.destroy
    redirect '/capacities'
  end
end 