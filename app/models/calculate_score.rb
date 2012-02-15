class CalculateScore < ActiveRecord::Base
  
  def self.get_score()
    uniqProducts = Product.select('DISTINCT pid')
    uniqProducts.each do |product|
      ranges = Hash.new{|h, k| h[k] = []}
      productData = Product.select(:batt_life).where("pid = ?", product.pid)
      productData.each do |data|
        battSplit = data.batt_life.split("-")
        ranges["low"] << Integer(battSplit[0])
        ranges["high"] << Integer(battSplit[1])
      end   
      finalLow = calcAvg(ranges["low"])
      finalHigh = calcAvg(ranges["high"]) 
      insert_feed_product_scores(product.pid, finalLow, finalHigh)  
    end

    # get all unique pids and get ready to group them
    # for each of the products that have the the same pids
    # grab the low and high numbers
    # average the lows
    # average the highs
    # Save the average range to feed_products db under avg_score
    
  end
  
  private
  
  def self.calcAvg(arr)
    return arr.inject{ |sum, el| sum + el }.to_f / arr.size 
  end
  
  def self.insert_feed_product_scores(id, low, high)
    avgScore = low.to_s + " - " + high.to_s
    @feedProduct = FeedProduct.find(id)
    @feedProduct.avg_score = avgScore
    @feedProduct.save
  end
  
end
