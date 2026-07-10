class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.text :description
      t.references :project, type: :uuid, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
