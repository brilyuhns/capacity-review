class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
