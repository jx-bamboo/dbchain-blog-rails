class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.integer :view
      t.integer :like
      t.integer :love
      t.string :status, default: 'public', null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :articles, :title, unique: true
  end
end
