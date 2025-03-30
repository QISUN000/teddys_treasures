require 'faker'
require 'net/http'
require 'uri'
require 'json'
require 'down'

# Clear existing products and categories if needed
# Only use this in development environment
if Rails.env.development?
  puts "Clearing existing products and categories..."
  OrderItem.destroy_all
  Order.destroy_all
  ProductCategory.destroy_all
  Product.destroy_all
  Category.destroy_all
end

# Create categories
puts "Creating categories..."
categories = [
  { name: 'Collars', description: 'Stylish and comfortable dog collars' },
  { name: 'Harnesses', description: 'Functional and fashionable dog harnesses' },
  { name: 'Leashes', description: 'Durable and stylish dog leashes' },
  { name: 'Beds', description: 'Cozy and comfortable dog beds' }
]

category_records = {}
categories.each do |category|
  category_records[category[:name]] = Category.find_or_create_by!(name: category[:name]) do |c|
    c.description = category[:description]
  end
end

# Product attributes for variety
puts "Preparing product attributes..."
materials = ['Leather', 'Nylon', 'Cotton', 'Hemp', 'Recycled', 'Vegan', 'Plush', 'Microfiber', 'Velvet', 'Wool']
patterns = ['Solid', 'Striped', 'Polka Dot', 'Checkered', 'Floral', 'Geometric', 'Paw Print', 'Bone', 'Hearts', 'Stars']
colors = ['Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Pink', 'Black', 'White', 'Brown', 'Orange', 'Teal', 'Navy', 'Burgundy', 'Gray']
sizes = ['Small', 'Medium', 'Large', 'X-Small', 'X-Large']
collections = ['Classic', 'Premium', 'Deluxe', 'Adventure', 'Cozy', 'Urban', 'Seasonal', 'Outdoor', 'Designer', 'Basic']

# Function to create a product with Faker data
def create_product(name, description, category_name, index)
  base_price = case category_name
               when 'Collars' then rand(1990..4990)
               when 'Harnesses' then rand(2990..5990)
               when 'Leashes' then rand(1590..3990)
               when 'Beds' then rand(4990..12990)
               end
  
  on_sale = [true, false].sample
  sale_price = on_sale ? (base_price * rand(0.7..0.9)).round(-1) : nil
  
  category_code = category_name[0..2].upcase
  sku = "#{category_code}-#{name[0..2].upcase}-#{index.to_s.rjust(3, '0')}"
  
  Product.create!(
    name: name,
    description: description,
    price: base_price,
    stock_quantity: rand(5..50),
    on_sale: on_sale,
    sale_price: sale_price,
    sku: sku
  )
end

# Function to fetch dog images from the Dog.ceo API
def fetch_dog_images(limit = 100)
  # Dog.ceo API provides random dog images
  url = URI("https://dog.ceo/api/breeds/image/random/#{limit}")
  
  response = Net::HTTP.get_response(url)
  return [] unless response.code == "200"
  
  data = JSON.parse(response.body)
  return [] unless data["status"] == "success"
  
  data["message"] # Array of image URLs
rescue => e
  puts "Error fetching from Dog.ceo API: #{e.message}"
  return []
end

# Fetch all dog images at once
puts "Fetching dog images from API..."
all_dog_images = fetch_dog_images(120) # Fetch more than needed in case some fail

# Product name templates by category
collar_templates = [
  "#{materials.sample} #{patterns.sample} Collar",
  "#{colors.sample} #{materials.sample} Collar",
  "#{collections.sample} #{materials.sample} Collar",
  "#{sizes.sample} Pet #{patterns.sample} Collar",
  "#{colors.sample} #{patterns.sample} #{collections.sample} Collar"
]

harness_templates = [
  "#{materials.sample} #{patterns.sample} Harness",
  "#{colors.sample} #{materials.sample} Harness",
  "#{collections.sample} #{sizes.sample} Harness",
  "#{sizes.sample} Pet #{patterns.sample} Harness",
  "#{colors.sample} #{patterns.sample} Support Harness"
]

leash_templates = [
  "#{materials.sample} #{patterns.sample} Leash",
  "#{colors.sample} #{materials.sample} Leash",
  "#{collections.sample} Training Leash",
  "#{sizes.sample} Pet #{patterns.sample} Leash",
  "#{colors.sample} Retractable #{materials.sample} Leash"
]

bed_templates = [
  "#{materials.sample} #{patterns.sample} Bed",
  "#{colors.sample} #{materials.sample} Pet Bed",
  "#{collections.sample} #{sizes.sample} Comfort Bed",
  "#{sizes.sample} Pet #{patterns.sample} Lounger",
  "#{colors.sample} #{patterns.sample} Orthopedic Bed"
]

total_products = 0
current_image_index = 0

# Create products for each category
categories.each do |category|
  puts "Creating #{category[:name]}..."
  
  templates = case category[:name]
              when 'Collars' then collar_templates
              when 'Harnesses' then harness_templates
              when 'Leashes' then leash_templates
              when 'Beds' then bed_templates
              end
  
  25.times do |i|
    name = "#{templates.sample}"
    description = "#{Faker::Marketing.buzzwords.capitalize} #{materials.sample.downcase} #{category[:name].downcase.singularize} with #{patterns.sample.downcase} pattern. #{Faker::Lorem.paragraph(sentence_count: 3)}"
    
    product = create_product(name, description, category[:name], i + 1)
    product.categories << category_records[category[:name]]
    
    # Attach image from API if available
    if current_image_index < all_dog_images.length
      begin
        image_url = all_dog_images[current_image_index]
        tempfile = Down.download(image_url)
        product.images.attach(io: tempfile, filename: "product_#{product.id}.jpg")
        current_image_index += 1
      rescue => e
        puts "Error downloading image: #{e.message}"
      end
    end
    
    total_products += 1
    puts "Created product: #{product.name}" if (i + 1) % 5 == 0
  end
end

# Create some multi-category products
puts "Creating multi-category products..."
5.times do |i|
  # Collar and leash sets
  materials_sample = materials.sample
  colors_sample = colors.sample
  name = "#{colors_sample} #{materials_sample} Collar & Leash Set"
  description = "Matching collar and leash set made with premium #{materials_sample.downcase} material. #{Faker::Lorem.paragraph(sentence_count: 3)}"
  
  product = create_product(name, description, 'Collars', 100 + i)
  product.categories << category_records['Collars']
  product.categories << category_records['Leashes']
  
  # Attach image from API if available
  if current_image_index < all_dog_images.length
    begin
      image_url = all_dog_images[current_image_index]
      tempfile = Down.download(image_url)
      product.images.attach(io: tempfile, filename: "product_#{product.id}.jpg")
      current_image_index += 1
    rescue => e
      puts "Error downloading image: #{e.message}"
    end
  end
  
  total_products += 1
end

puts "Seed completed successfully! Created #{total_products} products across #{categories.length} categories."