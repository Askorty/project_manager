class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :title
      t.text :description
      # Добавили type: :uuid, чтобы база ожидала UUID, а не число
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
