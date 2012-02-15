class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :feedproduct
  
  def self.search(search)
    if search
      where('name ILIKE ? ', "%#{search}%")
    else
      scoped
    end
  end

end