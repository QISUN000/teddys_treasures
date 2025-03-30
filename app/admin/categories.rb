ActiveAdmin.register Category do
  # Keep permit_params with image
  permit_params :name, :description, :image

  # Add a minimal form for image uploads
  form html: { multipart: true } do |f|
    f.inputs 'Category Details' do
      f.input :name
      f.input :description
      
      # Handle image upload
      if f.object.persisted? && f.object.image.attached?
        f.input :image, as: :file, hint: image_tag(url_for(f.object.image), width: '200')
      else
        f.input :image, as: :file
      end
    end
    f.actions
  end
end