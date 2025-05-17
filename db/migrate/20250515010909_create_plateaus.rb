class CreatePlateaus < ActiveRecord::Migration[8.0]
  def change
    create_table :plateaus do |t|
      t.integer :width, null: false
      t.integer :height, null: false

      t.timestamps
    end
  end
end
