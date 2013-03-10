class AddLastReadingToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_reading_at, :integer
  end
end
