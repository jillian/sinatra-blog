class CreateUsers < ActiveRecord::Migration[4.2]
  def change
  	create_table :users do |t|
      t.string  :username
      t.string  :email
      t.boolean :active 
      
      t.timestamps
    end
  end
end
