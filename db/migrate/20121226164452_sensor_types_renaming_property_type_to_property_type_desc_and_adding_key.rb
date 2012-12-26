class SensorTypesRenamingPropertyTypeToPropertyTypeDescAndAddingKey < ActiveRecord::Migration
  def up
    rename_column :sensor_types, :property_type, :property_type_desc
    add_column :sensor_types, :property_type_key, :string

    rename_column :device_types, :device_type, :device_type_desc
    add_column :device_types, :device_type_key, :string

  end

  def down
    rename_column :sensor_types, :property_type_desc , :property_type
    remove_column :sensor_types, :property_type_key

    rename_column :device_types, :device_type_desc , :device_type
    remove_column :device_types, :device_type_key
  end
end
