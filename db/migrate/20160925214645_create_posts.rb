class CreatePosts < ActiveRecord::Migration[4.2]
  def change
  	create_table :posts do |t|
  		t.string :title
  		t.text :body
 			t.timestamps 
 		end
 		Post.create(title: "Penny App", body: "Your personal finance coach")
 		Post.create(title: "Penny", body: "Track Your Money, Bills, Saving, and Spending")
 		Post.create(title: "Penny raises 1.2M", body: "Penny, a personal finance bot we reviewed last fall, has raised $1.2 million in seed funding from Social Capital. ... One unique thing about Penny is that the app only lets you send pre-populated messages, not natural language requests. ... Since we looked at Penny last year, the startup")
  end
end
