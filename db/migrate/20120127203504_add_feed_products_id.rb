class AddFeedProductsId < ActiveRecord::Migration
  def change
    change_column :products, :purchase_date, :date
  end
end
