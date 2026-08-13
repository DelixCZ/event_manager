class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.string :location
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.references :organizer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
