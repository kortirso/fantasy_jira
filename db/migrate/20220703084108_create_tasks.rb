class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false, default: ''
      t.integer :status, null: false, default: 0
      t.datetime :deadline_at
      t.datetime :canceled_at
      t.datetime :completed_at
      t.integer :lock_version
      t.timestamps
    end
  end
end
