class SensorTypesController < ApplicationController
    respond_to :json, :html
    def index
        @sensor_types = SensorType.all
        respond_with @sensor_types
    end

    def get_sensors_by_type
      @sensor_type = SensorType.find_by_property_type_desc(params[:type])
      if !@sensor_type.nil?
        @sensors = Sensor.find_all_by_sensor_type_id(@sensor_type.id)
        if !@sensors.nil?
          sensor_hash = @sensors.map { |s|
            Hash[
                :device => s.device.nil? ? nil : s.device.uri,
                :print_name => s.print_name,
                :sensor_type => @sensor_type.property_type_desc
            ]
          }
        end
      end
      render :json => sensor_hash
    end

    def new
        if (!params[:property_type_key].blank?)
            @sensor_type = SensorType.new(:property_type_key => params[:property_type_key],
                                          :property_type_desc => params[:property_type_desc],
                                          :metadata_json => params[:metadata_json])
            @sensor_type.save
            #redirect_to devices_path
        else
            @sensor_type = SensorType.new
                respond_to do |format|
                format.html
                format.json { render json: @sensor_type }
            end
        end
    end

    def create
        @sensor_type = SensorType.new(params[:sensor_type])
        if @sensor_type.save
            flash[:notice] = "Sensor Type created successfully !"
            redirect_to :action => "index"
        else
            flash[:error] = "Couldn't create the Sensor Type. Please try again."
            render "new"
        end
    end

    def edit
        @sensor_type = SensorType.find(params[:id])
    end

    def update
        @sensor_type = SensorType.find(params[:id])
        respond_to do |format|
            if @sensor_type.update_attributes(params[:sensor_type])
                flash[:notice] = 'Sensor Type was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @sensor_type.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @sensor_type = SensorType.find(params[:id])
        @sensor_type.destroy
        flash[:notice] = "Sensor Type deleted successfully !"
        redirect_to :action => "index"
    end
end
