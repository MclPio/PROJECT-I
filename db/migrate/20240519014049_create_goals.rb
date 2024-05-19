class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals do |t|
      t.string :name, null:false
      t.integer :duration, null: false
      t.boolean :completed, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
