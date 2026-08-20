class AddWaitlistedAtToEnrollments < ActiveRecord::Migration[8.1]
  def change
    add_column :enrollments, :waitlisted_at, :datetime
    add_index :enrollments, :waitlisted_at

    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          UPDATE enrollments
          SET waitlisted_at = created_at
          WHERE status = 'waitlisted'
        SQL
      end
    end
  end
end
