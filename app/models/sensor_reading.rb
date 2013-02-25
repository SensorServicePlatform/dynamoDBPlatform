require "net/http"

class SensorReading < ActiveRecord::Base
  def self.pull_readings(sensor_reading_table)
    reading_json = Net::HTTP.get(URI('http://jeenetgw01.sv.cmu.edu/data.json'))
    reading_hash = ActiveSupport::JSON.decode(reading_json)

    if (reading_hash.is_a? Array)
      sensor_reading_table.batch_write(
        :put => reading_hash
      )
    else
      sensor_reading_table.items.create(reading_hash)
    end
    puts "pulled reading " + reading_json
    self.delay({:run_at => 1.minute.from_now}).pull_readings sensor_reading_table
  end

  # called from initializer
  def self.start_pulling_readings
    sensor_readings_table_name = "SensorReadingV7"
    db = AWS::DynamoDB.new
    @sensor_reading_table = db.tables[sensor_readings_table_name].load_schema
    self.pull_readings @sensor_reading_table
  end
end
