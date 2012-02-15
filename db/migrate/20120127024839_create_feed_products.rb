class CreateFeedProducts < ActiveRecord::Migration
  def change
    create_table :feed_products do |t|
      t.string :name
      t.text :summary
      t.string :url
      t.datetime :published_at

      t.timestamps
    end
  end
end
