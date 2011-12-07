class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :access_token
      t.string :access_secret
      t.string :netflix_user_id
      t.string :netflix_sub_user_id

      t.timestamps
    end
  end
end
