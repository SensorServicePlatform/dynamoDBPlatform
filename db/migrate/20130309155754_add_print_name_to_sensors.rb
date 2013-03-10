class AddPrintNameToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :print_name, :string
  end
end
