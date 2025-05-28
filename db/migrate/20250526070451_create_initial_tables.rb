class CreateInitialTables < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.boolean :admin, default: false
      t.timestamps
    end

    create_table :categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.timestamps
    end

    create_table :blogs do |t|
      t.string :title, null: false
      t.references :category, foreign_key: true
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: 'draft' # Possible values: draft, published, archived
      t.datetime :published_at, null: true
      t.timestamps
    end

    create_table :comments do |t|
      t.references :blog, null: false, foreign_key: true
      t.string :author, null: false
      t.references :user, foreign_key: true # Optional, if the comment is by a registered user
      t.text :content, null: false
      t.timestamps
    end
  end
end
