class ChangeColumnNameDeviceNameInDeviceAgent < ActiveRecord::Migration
  def up
    rename_column :device_agents, :device_name, :print_name
  end

  def down
  end
end
