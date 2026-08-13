class CreateOrganizers < ActiveRecord::Migration[8.1]
  def change
    create_table :organizers do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :organizers, :email, unique: true
  end
end
