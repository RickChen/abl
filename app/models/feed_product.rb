require 'open-uri'

class FeedProduct < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_name, :against => :name, :using => :tsearch
  
  has_many :products, :dependent => :destroy, :foreign_key => "pid"
  
  def self.search(search)
    if search
      where('name ILIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.initial_verge_feeds()
    update_the_verge_feeds("http://www.theverge.com/products/categories/cellphones/3",41);
    puts "Adding CellPhones"
    update_the_verge_feeds("http://www.theverge.com/products/categories/tablets/8",12);
    puts "Adding Tablets"
    update_the_verge_feeds("http://www.theverge.com/products/categories/laptops/6",30);
    puts "Adding Laptops"
    update_the_verge_feeds("http://www.theverge.com/products/categories/cameras/2",35);
    puts "Adding Cameras"
    update_the_verge_feeds("http://www.theverge.com/products/categories/e-readers/5",3);
    puts "Adding E-Readers"
    update_the_verge_feeds("http://www.theverge.com/products/categories/portable-consoles/13",3); 
    puts "Adding Portable Consoles"
    update_the_verge_feeds("http://www.theverge.com/products/categories/pmps/7",10)                   
    puts "Adding Portable Media Players"
  end
  
  def self.update_verge_feeds()
    update_the_verge_feeds("http://www.theverge.com/products/categories/cellphones/3", 1);
    puts "Updating CellPhones"
    update_the_verge_feeds("http://www.theverge.com/products/categories/tablets/8", 1);
    puts "Updating Tablets"
    update_the_verge_feeds("http://www.theverge.com/products/categories/laptops/6", 1);
    puts "Updating Laptops"
    update_the_verge_feeds("http://www.theverge.com/products/categories/cameras/2", 1);
    puts "Updating Cameras"
    update_the_verge_feeds("http://www.theverge.com/products/categories/e-readers/5", 1);
    puts "Updating E-Readers"
    update_the_verge_feeds("http://www.theverge.com/products/categories/portable-consoles/13", 1); 
    puts "Updating Portable Consoles"
    update_the_verge_feeds("http://www.theverge.com/products/categories/pmps/7", 1)                   
    puts "Updating Portable Media Players"
  end
  
  def self.update_amazon_feeds()
    feedUrls = [
      "http://www.amazon.com/gp/rss/bestsellers/electronics/ref=zg_bs_electronics_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/electronics/281052/ref=zg_bs_281052_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/electronics/172421/ref=zg_bs_172421_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/electronics/3350161/ref=zg_bs_3350161_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/electronics/699138011/ref=zg_bs_699138011_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/electronics/1232597011/ref=zg_bs_1232597011_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/pc/565108/ref=zg_bs_565108_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/pc/1232596011/ref=zg_bs_1232596011_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/pc/172594/ref=zg_bs_172594_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/toys-and-games/166164011/ref=zg_bs_166164011_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/wireless/2407747011/ref=zg_bs_2407747011_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/wireless/2407749011/ref=zg_bs_2407749011_rsslink",
      "http://www.amazon.com/gp/rss/bestsellers/electronics/172493/ref=zg_bs_172493_rsslink",
      "http://www.amazon.com/gp/rss/new-releases/electronics/ref=zg_bsnr_electronics_rsslink"     
    ]
    update_from_feeds(feedUrls,"amazon")
  end

  def self.update_the_verge_feeds(page_url, pages)
    
    verge_products = []
    index = 1    
    
    begin
      if(index > 1) 
        all_page_url = "#{page_url}/#{index}"  
      else
        all_page_url = page_url
      end
      doc = Nokogiri::HTML(open(all_page_url))
      allProducts = doc.css(".product-grid-item .label")
      
      unless allProducts.nil?
        allProducts.each do |product|
          brand = product.css(".by a").text
          productName = product.css("h3 a").text
          finalProductName = "#{brand} #{productName}"
          verge_products.push(finalProductName)
        end
      end
      
      index += 1
      puts "Product Page #{index}"
      
    end while index <= pages
    add_verge_entries(verge_products)
  end
  
  def self.update_from_feeds(feed_urls, source)
    feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)
    feeds.each do |feed_url, feed|
      if source.casecmp("amazon") == 0
        add_amazon_entries(feed.entries)
      end
    end
  end
  
  def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
    loop do
      sleep delay_interval
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end
  end
  
  private
  
  def self.add_verge_entries(entries)
    entries.each do |entry|
      unless exists? :name => entry
        create!(
          :name => entry
        )
      end 
    end
    puts "Inserted all verge products!"
  end
  
  def self.add_amazon_entries(entries)
    entries.each do |entry|
      #remove amazon #from the beginning
      product_display = entry.title.split(/: */)
      product_display_name = product_display.at(1)
      unless exists? :summary => entry.title
                   create!(
                     :name         => product_display_name,
                     :summary      => entry.title,
                     :url          => entry.url,
                     :published_at => entry.published
                   )
      end
   end
   puts "Done Adding Amazon Feeds"
  end
end
