class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :body, :index => true
      t.string :author_name
      t.string :author_url
      t.string :url
      t.string :source_uid
      t.timestamp :posted_at

      t.references :source, :index => true

      t.timestamps
    end
  end
end
