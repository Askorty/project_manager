class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks, id: :string do |t|
      t.string :title
      t.text :description
      t.references :project, type: :string, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
