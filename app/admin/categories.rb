ActiveAdmin.register Category do
  permit_params :name, :description, :image

  index do
    selectable_column
    id_column
    column :name
    column :description do |category|
      truncate(category.description, length: 100)
    end
    column :image do |category|
      image_tag url_for(category.image), width: '100' if category.image.attached?
    end
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs 'Category Details' do
      f.input :name
      f.input :description
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(url_for(f.object.image), width: '200') : content_tag(:span, 'No image yet')
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :image do |category|
        image_tag url_for(category.image), width: '200' if category.image.attached?
      end
      row :created_at
      row :updated_at
    end
  end
end