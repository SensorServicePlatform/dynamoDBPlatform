class SensorType < ActiveRecord::Base
    attr_accessible :property_type_key,:property_type_desc, :metadata_json
    has_many :sensors
    validates :metadata_json, :json_format => true
end
