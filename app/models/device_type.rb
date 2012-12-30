class DeviceType < ActiveRecord::Base
    attr_accessible :device_type_key, :device_type_desc, :version, :manufacturer, :metadata_json, :default_config
    has_many :devices
    validates :metadata_json, :json_format => true
end
