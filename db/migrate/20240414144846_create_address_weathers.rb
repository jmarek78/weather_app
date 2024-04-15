class CreateAddressWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :address_weathers do |t|
      t.decimal :lat
      t.decimal :lon
      t.string :display_name
      t.integer :zip
      t.string :icon
      t.integer :temp
      t.integer :humidity
      t.integer :wind
      t.integer :high
      t.integer :low
      t.datetime :time

      t.timestamps
    end
  end
end
