class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
