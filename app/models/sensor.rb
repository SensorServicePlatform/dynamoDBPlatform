class Sensor < ActiveRecord::Base
  attr_accessible :guid, :uri, :print_name, :sensor_type_id, :min_value, :max_value, :device_guid, :device_id, :metadata_json, :location
  #validates :uri, :uniqueness => true
  validates :metadata_json, :json_format => true
  belongs_to :device
  belongs_to :sensor_type
  has_one :location, :dependent => :destroy

	before_create do
	    self.guid = SecureRandom.uuid
	end
end