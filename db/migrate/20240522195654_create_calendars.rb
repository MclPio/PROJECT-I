class CreateCalendars < ActiveRecord::Migration[7.1]
  def change
    create_table :calendars do |t|
      t.string :calendar_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :calendars, :calendar_id, unique: true
  end
end
