class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]


  def geolocation
    @start = params["start"]
    @end = params["end"]
  end


  # GET /stations
  # GET /stations.json
  def index
    if params['min_lng'].nil? 
      @stations = Station.all.paginate(page:params[:page])
    else
      render json: Station.where(baidu_lng: params['min_lng'] .. params['max_lng'],baidu_lat:params['min_lat']..params['max_lat']).map { |e| {id:e.id,lat:e.baidu_lat,lng:e.baidu_lng,name:e.name}   }
    end
  end

  def search_by_name
    @station = Station.find_by name: params[:name]

    render json: @station
  end

  def search
    @stations =  Station.order(:name).where("name like ?","%#{params[:term]}%")
    render json: @stations.map { |e| e.name }
  end

  # GET /stations/1
  # GET /stations/1.json
  def show
    respond_to do |format|
     format.js
     format.html
    end
  end

  # GET /stations/new
  def new
    @station = Station.new
  end

  # GET /stations/1/edit
  def edit
  end

  # POST /stations
  # POST /stations.json
  def create
    @station = Station.new(station_params)
    respond_to do |format|
      if @station.save
        format.html { redirect_to @station, notice: 'Station was successfully created.' }

        format.js

        format.json { render action: 'show', status: :created, location: @station }
      else
        format.html { render action: 'new' }
        format.js
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stations/1
  # PATCH/PUT /stations/1.json
  def update
    respond_to do |format|

      if @station.update(station_params)
        format.js 
        format.html { redirect_to @station, notice: 'Station was successfully updated.' }

        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.json
  def destroy
    @station.destroy
    respond_to do |format|
      format.html { redirect_to stations_url }
      format.js
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station
      @station = Station.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def station_params
      params.require(:station).permit(:name, :lat, :lng,:baidu_lat,:baidu_lng, :description, :markup,:pos_type)
    end
end
