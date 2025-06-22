class CreateProjectAllocations < ActiveRecord::Migration[8.0]
  def change
    create_table :project_allocations do |t|
      t.references :project, null: false, foreign_key: true
      t.date :period_start, null: false
      t.string :period_type, null: false, default: 'week'
      t.decimal :allocation, null: false
      t.string :source, null: false, default: 'manual'
      t.timestamps
    end

    add_index :project_allocations, [:project_id, :period_start, :period_type], unique: true, name: 'index_project_allocations_on_project_period'
  end
end
