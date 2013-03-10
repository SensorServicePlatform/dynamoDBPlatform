class ChangeDefaultConfigToTextInDeviceTypes < ActiveRecord::Migration
  def up
    change_column :device_types, :default_config, :text
  end

  def down
    # this may cause trouble if default config is longer than 255 characters
    change_column :device_types, :default_config, :string
  end
end
