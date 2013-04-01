class ChangeSensorsSensorTypeIdToInteger < ActiveRecord::Migration
  def change
    change_column :sensors, :sensor_type_id, :integer
  end
end
