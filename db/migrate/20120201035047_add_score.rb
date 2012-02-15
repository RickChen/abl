class AddScore < ActiveRecord::Migration
  def change
    add_column :feed_products, :avg_score, :string
  end
end
