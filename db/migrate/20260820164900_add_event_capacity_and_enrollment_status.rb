class AddEventCapacityAndEnrollmentStatus < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :capacity, :integer, null: false, default: 10
    add_column :enrollments, :status, :string, null: false, default: "confirmed"
    add_index :enrollments, :status
  end
end
