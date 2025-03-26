# app/admin/pages.rb
ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :created_at
    actions
  end

  filter :title
  filter :slug
  filter :created_at

  form do |f|
    f.inputs 'Page Details' do
      f.input :title
      f.input :slug, hint: 'Used for URL. Example: "about" or "contact"'
      f.input :content, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |page|
        simple_format page.content
      end
      row :created_at
      row :updated_at
    end
  end
end