# app/admin/products.rb
ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :on_sale, :sale_price, :sku, 
                category_ids: [], images: []

  index do
    selectable_column
    id_column
    column :name
    column :sku
    column :price do |product|
      number_to_currency(product.price/100.0)
    end
    column :sale_price do |product|
      number_to_currency(product.sale_price/100.0) if product.on_sale?
    end
    column :stock_quantity
    column :on_sale
    column :created_at
    actions
  end

  filter :name
  filter :sku
  filter :price
  filter :stock_quantity
  filter :on_sale
  filter :created_at

  form html: { multipart: true } do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :sku
      f.input :description, as: :text
      f.input :price
      f.input :on_sale
      f.input :sale_price
      f.input :stock_quantity
      f.input :categories, as: :check_boxes
      f.input :images, as: :file, input_html: { multiple: true }
    end

    if f.object.images.attached?
      div class: 'panel' do
        h3 'Current Images'
        div class: 'existing-images' do
          f.object.images.each do |image|
            div class: 'image-container' do
              image_tag url_for(image), width: '200'
            end
          end
        end
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :name
      row :sku
      row :description
      row :price do |product|
        number_to_currency(product.price/100.0)
      end
      row :on_sale
      row :sale_price do |product|
        number_to_currency(product.sale_price/100.0) if product.on_sale?
      end
      row :stock_quantity
      row :categories do |product|
        product.categories.map(&:name).join(', ')
      end
      row :created_at
      row :updated_at
      row :images do |product|
        ul do
          product.images.each do |image|
            li do
              image_tag url_for(image), width: '200'
            end
          end
        end
      end
    end
  end
end