class CreateRovers < ActiveRecord::Migration[8.0]
  def change
    create_table :rovers do |t|
      t.integer :pos_x, null: false
      t.integer :pos_y, null: false
      t.string :direction, null: false
      t.references :plateau, null: false, foreign_key: true

      t.timestamps
    end
  end
end
