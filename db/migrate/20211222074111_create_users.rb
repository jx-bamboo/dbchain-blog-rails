class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :password_digest
      # t.string :encrypted_password

      t.string :phone_area
      t.string :email
      t.string :avatar
			t.string :nickname
      t.integer :sex
      t.date :age
      t.string :description
      t.string :code
      t.string :role, default: 'user', null: false

      t.timestamps
    end
    add_index :users, :phone_number, unique: true
    add_index :users, :email, unique: true
  end
end
