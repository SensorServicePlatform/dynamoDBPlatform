class DevicesController < ApplicationController
    respond_to :json, :html

    def index
        @devices = Device.all
        respond_with @devices
    end

    def get_devices
        @devices = Device.all
        device_hash = @devices.collect { |d|
          loc = {}
          if d.location.nil?
            loc = {:lat => '', :lon => '', :alt => ''}
          else
            loc[:print_name] = d.location.print_name.nil? ? nil : d.location.print_name
            loc[:lat] = d.location.lat.nil? ? nil : d.location.lat
            loc[:lon] = d.location.lon.nil? ? nil : d.location.lon
            loc[:alt] = d.location.alt.nil? ? nil : d.location.alt
            loc[:format] = d.location.format.nil? ? nil : d.location.format
          end
          Hash[
            :guid => d.guid,
            :uri => d.uri,
            :print_name => d.print_name,
            :device_agent => d.device_agents,
            :location => loc,
            :sensors => d.sensors.collect{|s| Hash[s.guid => s.sensor_type.property_type_desc]}
          ]
        }
        render :json => device_hash
    end

    def new
        @location = Location.new
        @device_types = DeviceType.all
        @device_agents = DeviceAgent.all
        if (!params[:uri].blank? && !params[:device_type_id].blank?)   # && !params[:physical_location].nil? && !params[:network_address].nil?)
            @device = Device.new(:uri => params[:uri], :device_type_id => params[:device_type_id])
            @device.network_address = params[:network_address] unless params[:network_address].blank?
            @device.save
            #redirect_to devices_path
        else
            @device = Device.new
            respond_to do |format|
                format.html # new.html.erb
                format.json { render json: @device }
            end
        end
    end

    def create
      @device = Device.new(params[:device])
      if @device.save

        @location = Location.create({
            :print_name => params[:print_name],
            :lat => params[:lat],
            :lon => params[:lon],
            :alt => params[:alt],
            :format => params[:pos_fmt]
          })
        @device.location = @location

        if (!params[:device][:device_agent_guid].blank?)
          device_agent = DeviceAgent.find_by_guid(params[:device][:device_agent_guid])
          @device.device_agents << device_agent
        end

        # pre-populate sensors for using the device type's default config
        if !(@device.device_type.default_config.blank?)

          # get the sensor types to add by default for a device of this config
          default_config_json = JSON.parse(@device.device_type.default_config)

          ## initialize the uri for this device (only for sensor creation)
          # @device.uri = @device.id.to_s << "." << @device.uri << ".device.sv.cmu.edu"

          default_config_json["sensor_type_and_name"].each do |pt|
            # find Sensor type
            sensor_type = pt[0]
            sensor_name = pt[1]
            st = SensorType.find_by_property_type_desc(sensor_type)
            # create Sensor with this Sensor Type
            [{
                 :print_name => sensor_name,
                 :sensor_type_id => st.id,
                 #:uri => @device.uri,
                 :device_id => @device.id,
                 :device_guid => @device.guid
             }].each do |attributes|
               s = Sensor.create(attributes)
               #s.uri = s.id.to_s << "." << temp_device_uri << s.uri
               s.save
               # add this Sensor to the Sensor Type
               st.sensors << s
               # add Sensor to the device
               @device.sensors << s
            end
          end

          @device.save
        end
        flash[:notice] = "Device created successfully !"
        redirect_to :action => "index"
      else
        #format.html { render action: "new" }
        render "new"
        format.js
      end
    end

    def edit
        @device = Device.find(params[:id])
        # @device.uri = @device.uri.sub(/#{@device.id}\./, '')
        # @device.uri = @device.uri.sub(/\.device\.sv\.cmu\.edu/, '')
        @location = @device.location.nil? ? Location.new : @device.location
        @device_types = DeviceType.all
        @device_agents = DeviceAgent.all
        @sensors = @device.sensors
    end

    def update
        @device = Device.find(params[:id])

        device_agent = DeviceAgent.find_by_guid(params[:device][:device_agent_guid])
        @device.device_agents << device_agent unless device_agent.nil? or @device.device_agents.include? device_agent

        respond_to do |format|
            if @device.update_attributes(params[:device])
                @location = Location.create({
                    :print_name => params[:print_name],
                    :lat => params[:lat],
                    :lon => params[:lon],
                    :alt => params[:alt],
                    :format => params[:pos_fmt]
                  })
                @device.location = @location
                # @device.device_agents << params[:device_agent]
                # @device.uri = @device.id.to_s << "." << @device.uri << ".device.sv.cmu.edu"
                @device.save
                flash[:notice] = 'Device was successfully updated.'
                format.html { redirect_to :action => "index" }
                format.json { head :no_content }
            else
              format.html { render action: "edit" }
              format.json { render json: @device.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @device = Device.find(params[:id])
        @device.destroy
        flash[:notice] = "Device deleted successfully !"
        redirect_to :action => "index"
    end

    def show
        redirect_to :action => "edit"
    end

end


