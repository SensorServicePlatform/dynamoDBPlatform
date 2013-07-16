require "aws"

class SensorReadingsController < ApplicationController
  respond_to :html, :json
  before_filter :initialize_DynamoDB

  #def index
  #  json_array = []
  #
  #  # This is incredibly slow because it gets EVERYTHING.
  #  # It is not optimized like the query method.
  #  # I did not use query(..) because it requires a hash_value
  #  @sensor_reading_table.items.each do |reading|
  #    run_conversions(reading)
  #    json_array << {
  #        :id => id,
  #        :temp => reading.attributes["temp"],
  #        :timestamp => reading.attributes["timestamp"]
  #    }
  #  end
  #
  #  render :json => json_array
  #end

  def show
    id = params[:id]
    # temporary solution to query device location
    device = Device.find_by_network_address(id)
    if !device.nil?
      device_loc = device.location.print_name
    end
    start_time = params[:start_time].to_i
    end_time = params[:end_time].to_i
    number_of_tuples = params[:tuples].to_i

    if !(start_time > 0 and end_time > start_time)
      end_time = Time.now.to_i * 1000
      start_time = end_time - 3600000
    end

    # The query method requires a hash_value
    readings = @sensor_reading_table.items.query(
        :hash_value => id,
        :range_value => start_time..end_time,
        :select => :all)

    # Convert the Enumerator to an Array so that we can index into it.
    # Enumerator.find(id) returns another Enumerator that does not
    # have the expected 'attributes' hash
    readings = readings.to_a

    # TODO: re-work on conversion
    #readings.each do |reading|
    #  run_conversions(reading)
    #end

    json_array = []

    if number_of_tuples > 0
      number_of_readings = readings.count
      readings_per_tuple = (number_of_readings / number_of_tuples).to_i
      if readings_per_tuple > 0
        number_of_tuples.times do |tuple_index|
          start_index = tuple_index * readings_per_tuple
          end_index = start_index + readings_per_tuple
          tuple_readings = readings[start_index..end_index]
          tuple_timestamps = tuple_readings.collect { |r| r.attributes["timestamp"] }
          tuple_temp_readings = tuple_readings.collect { |r| r.attributes["temp"] }
          json_array << {
              :id => id,
              :loc => device_loc,
              :average_timestamp => tuple_timestamps.average.round,
              :first => tuple_temp_readings.first,
              :last => tuple_temp_readings.last,
              :min => tuple_temp_readings.min,
              :max => tuple_temp_readings.max,
              :average => tuple_temp_readings.average
          }
        end
      end
    else
      readings.each do |reading|
        json_array << reading.attributes
      end
    end

    render :json => json_array
  end

  def get_latest_reading
    id = params[:id]
    device = Device.find_by_network_address(id)
    if device.nil?
      render :json => nil
      return
    end
    last_reading_time = device.last_reading_at * 1000 # convert to millisecond
    reading = @sensor_reading_table.items.query(
        :hash_value => id,
        :range_value => last_reading_time,
        :select => :all)
    if !reading.nil?
      render :json => reading.to_a.last.attributes
    else
      render :json => nil
    end
  end

  def get_last_reading_time_for_all_devices
    last_reading_time = Hash.new
    Device.all.each do |device|
      last_reading_time[device.network_address] = device.last_reading_at
    end
    render :json => last_reading_time
  end

  def update_last_reading_time(reading)
    # reading's id is device's network address
    device = Device.find_by_network_address(reading["id"])
    unix_epoch_time = reading["timestamp"]
    if (unix_epoch_time.to_s.length == 13)
      # timestamp is in milliseconds eg. 1363041237000
      unix_epoch_time = unix_epoch_time / 1000
    end
    if !device.nil?
      device.last_reading_at = unix_epoch_time
      device.save
    end
  end

  def convert_timestamp_to_millisecond(reading)
    if (reading["timestamp"].to_i.to_s.length == 10)
      # timestamp is in seconds, convert it to milliseconds
      reading["timestamp"] = reading["timestamp"] * 1000
    end
  end

  def forward_json(reading_json)
    uri = URI.parse("http://cmu-sensor-network.herokuapp.com/sensors")
    post_json_request = Net::HTTP::Post.new(uri.request_uri)
    post_json_request.add_field("Content-Type", "application/json")
    post_json_request.body = reading_json
    http = Net::HTTP::new(uri.host, uri.port)
    response = http.request(post_json_request)
    return response
  end

  def create
    reading_json = request.body.read
    reading_hash = ActiveSupport::JSON.decode(reading_json)

    if (reading_hash.is_a? Array)
      reading_hash.each do |reading|
        convert_timestamp_to_millisecond(reading)
        update_last_reading_time(reading)
      end
      @sensor_reading_table.batch_write(
        :put => reading_hash
      )
    else
      convert_timestamp_to_millisecond(reading_hash)
      @sensor_reading_table.items.create(reading_hash)
      update_last_reading_time(reading_hash)
    end

    forward_json(reading_json)
    render :text => "Success", :status => 200, :content_type => 'text/html'
  end

  def initialize_DynamoDB
    sensor_readings_table_name = "SensorReadingV7"
    db = AWS::DynamoDB.new
    @sensor_reading_table = db.tables[sensor_readings_table_name].load_schema
  end

  private

  def run_conversions(reading)
    ["temp"].each do |type|
      value = reading.attributes[type]
      reading.attributes[type] = convert(value, type)
    end
  end

  def convert(x, type)
    # 'x' must be an integer to be used in equations
    x = x.to_i
    conversion = Conversion.find_by_quantity(type)
    a = conversion.a
    b = conversion.b
    return a * x + b
  end

end