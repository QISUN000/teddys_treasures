# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

OrderItem.destroy_all
Order.destroy_all
ProductCategory.destroy_all
Product.destroy_all
Category.destroy_all
Address.destroy_all
Page.destroy_all
Province.destroy_all
User.destroy_all
AdminUser.destroy_all


AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

puts "Creating provinces..."
provinces = [
  { name: 'Alberta', code: 'AB', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'British Columbia', code: 'BC', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'Manitoba', code: 'MB', gst_rate: 5.0, pst_rate: 7.0, hst_rate: 0.0 },
  { name: 'New Brunswick', code: 'NB', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Newfoundland and Labrador', code: 'NL', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Northwest Territories', code: 'NT', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Nova Scotia', code: 'NS', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Nunavut', code: 'NU', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 },
  { name: 'Ontario', code: 'ON', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 13.0 },
  { name: 'Prince Edward Island', code: 'PE', gst_rate: 0.0, pst_rate: 0.0, hst_rate: 15.0 },
  { name: 'Quebec', code: 'QC', gst_rate: 5.0, pst_rate: 9.975, hst_rate: 0.0 },
  { name: 'Saskatchewan', code: 'SK', gst_rate: 5.0, pst_rate: 6.0, hst_rate: 0.0 },
  { name: 'Yukon', code: 'YT', gst_rate: 5.0, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces.each do |province|
  Province.create!(province)
end

# Create categories
puts "Creating categories..."
categories = [
  { name: 'Collars', description: 'Stylish and comfortable dog collars' },
  { name: 'Harnesses', description: 'Functional and fashionable dog harnesses' },
  { name: 'Leashes', description: 'Durable and stylish dog leashes' },
  { name: 'Beds', description: 'Cozy and comfortable dog beds' }
]

categories.each do |category|
  Category.create!(category)
end

# Create static pages
puts "Creating static pages..."
pages = [
  { 
    title: 'About Us', 
    slug: 'about', 
    content: "# About Teddy's Treasures\n\nFounded in 2020, Teddy's Treasures is a boutique pet accessories brand dedicated to creating stylish, high-quality products for your furry friends. Our mission is to combine functionality with fashion, ensuring your pets look their best while enjoying comfort and durability.\n\n## Our Story\n\nThe brand was inspired by our founder's dog, Teddy, a spirited Bichon Frise with a taste for the finer things in life. When she couldn't find accessories that matched both Teddy's personality and her own aesthetic standards, she decided to create her own.\n\nStarting with a small collection of handcrafted collars, Teddy's Treasures has grown to offer a comprehensive range of pet accessories, each designed with love and attention to detail.\n\n## Our Products\n\nAll Teddy's Treasures products are crafted using premium materials, ensuring they're not only beautiful but built to last. We work with skilled artisans who share our passion for quality and design, resulting in products that both pets and their owners love.\n\n## Our Commitment\n\nWe're committed to creating products that enhance the bond between pets and their owners. We believe that every pet deserves to feel special, and every owner deserves to feel proud of their furry companion."
  },
  { 
    title: 'Contact Us', 
    slug: 'contact', 
    content: "# Contact Teddy's Treasures\n\n## Customer Service\n\nPhone: (204) 555-1234\nEmail: info@teddystreasures.com\n\n## Hours of Operation\n\nMonday to Friday: 9am - 5pm CST\nSaturday: 10am - 4pm CST\nSunday: Closed\n\n## Location\n\nTeddy's Treasures\n123 Main Street\nWinnipeg, Manitoba R3C 1A3\nCanada\n\n## Send Us a Message\n\nHave questions or feedback? We'd love to hear from you! Fill out the contact form below and one of our team members will get back to you as soon as possible."
  },
  { 
    title: 'FAQ', 
    slug: 'faq', 
    content: "# Frequently Asked Questions\n\n## Products\n\n### How do I determine the right size for my pet?\n\nMeasuring your pet correctly is essential for a perfect fit. Please refer to our sizing guides for each product category. Generally, you'll need to measure your dog's neck circumference for collars, chest circumference for harnesses, and weight for beds.\n\n### Where are Teddy's Treasures products made?\n\nAll our products are designed in Winnipeg, Manitoba and manufactured in our partner workshops in Canada and Europe using high-quality materials.\n\n### How do I care for my Teddy's Treasures products?\n\nMost of our products can be hand washed with mild soap and air dried. For specific care instructions, please refer to the product page or the care label attached to your item.\n\n## Orders & Shipping\n\n### How long will it take to receive my order?\n\nOrders typically ship within 1-2 business days. Delivery times vary depending on your location, typically 2-5 business days within Canada.\n\n### Do you offer international shipping?\n\nYes, we ship to most countries worldwide. International shipping rates and delivery times will be calculated at checkout.\n\n### What is your return policy?\n\nWe offer a 30-day return policy for unused items in original packaging. Custom orders are non-returnable. Please contact our customer service team to initiate a return."
  }
]

pages.each do |page|
  Page.create!(page)
end

# Create initial products
puts "Creating initial products..."
collar = Product.create!(
  name: 'Teddy Collar',
  description: 'A stylish collar with soft fleece lining - ideal combination of elegance for your pet. Plush trim on both sides and high-quality hardware guarantees reliability and longevity. Suitable for everyday use and cold weather.',
  price: 3390,
  stock_quantity: 20,
  on_sale: false,
  sale_price: nil,
  sku: 'COL-TED-001'
)

harness = Product.create!(
  name: 'Teddy Harness',
  description: 'Comfortable harness with soft fleece lining and adjustable straps for a perfect fit. Designed for both comfort and style with durable hardware.',
  price: 4390,
  stock_quantity: 15,
  on_sale: false,
  sale_price: nil,
  sku: 'HAR-TED-001'
)

leash = Product.create!(
  name: 'Basic Leash',
  description: 'Classic leather leash with comfortable grip and strong hardware. Perfect companion for daily walks.',
  price: 3590,
  stock_quantity: 25,
  on_sale: false,
  sale_price: nil,
  sku: 'LSH-BAS-001'
)

bed = Product.create!(
  name: 'Cloudy Bed',
  description: 'Soft, plush bed with raised edges for support and extra comfort. Machine washable with removable cover.',
  price: 8990,
  stock_quantity: 10,
  on_sale: true,
  sale_price: 7990,
  sku: 'BED-CLD-001'
)

# Assign categories
collar.categories << Category.find_by(name: 'Collars')
harness.categories << Category.find_by(name: 'Harnesses')
leash.categories << Category.find_by(name: 'Leashes')
bed.categories << Category.find_by(name: 'Beds')

puts "Seed completed successfully!"AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?