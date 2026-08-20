class CreateEnrollmentsAndNormalizeAttendees < ActiveRecord::Migration[8.1]
  def up
    create_table :enrollments do |t|
      t.references :event, null: false, foreign_key: true
      t.references :attendee, null: false, foreign_key: true

      t.timestamps
    end

    add_index :enrollments, [ :event_id, :attendee_id ], unique: true

    execute <<~SQL.squish
      INSERT INTO enrollments (event_id, attendee_id, created_at, updated_at)
      SELECT event_id, id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM attendees
      WHERE event_id IS NOT NULL
    SQL

    remove_reference :attendees, :event, foreign_key: true
    add_index :attendees, :email, unique: true
  end

  def down
    add_reference :attendees, :event, foreign_key: true

    execute <<~SQL.squish
      UPDATE attendees
      INNER JOIN enrollments ON enrollments.attendee_id = attendees.id
      SET attendees.event_id = enrollments.event_id
    SQL

    change_column_null :attendees, :event_id, false
    remove_index :attendees, :email
    drop_table :enrollments
  end
end
