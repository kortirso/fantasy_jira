class CreateTasksApprovements < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks_approvements do |t|
      t.integer :task_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
    add_index :tasks_approvements, [:task_id, :user_id], unique: true
  end
end
