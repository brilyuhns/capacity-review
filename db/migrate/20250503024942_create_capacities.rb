class CreateCapacities < ActiveRecord::Migration[8.0]
  def change
    create_table :capacities do |t|
      t.date :period_start
      t.string :period_type, default: 'week'
      t.decimal :gross_capacity, null: false
      t.decimal :planned_leaves, null: false, default: 0
      t.decimal :unplanned_leaves, null: false, default: 0
      t.string :source, null: false, default: 'imported'
      t.timestamps
    end

    add_index :capacities, [:period_start, :period_type], unique: true
  end
end

