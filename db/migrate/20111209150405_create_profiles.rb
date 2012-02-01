class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :netflix_user_id
      t.string :name
      t.boolean :primary
      t.integer :position
      
      t.references :user

      t.timestamps
    end
  end
end
