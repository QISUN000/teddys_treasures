# app/admin/pages.rb
ActiveAdmin.register Page do
  # Use slug as the identifying parameter instead of ID
  controller do
    def find_resource
      Page.find_by(slug: params[:id])
    end
    
    def update
      if resource.slug.in?(['about', 'contact']) && params[:page][:slug] != resource.slug
        flash[:error] = "Cannot change slug for system pages"
        redirect_to edit_admin_page_path(resource) and return
      end
      super
    end
  end
  
  # Rest of your configuration remains the same
  permit_params :title, :content, :slug
  
  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :updated_at
    actions
  end

  filter :title
  filter :content
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'Page Details' do
      f.input :title
      f.input :slug, input_html: { readonly: f.object.slug.in?(['about', 'contact']) },
              hint: 'URL identifier (e.g., "about" creates /about)'
      f.input :content, as: :text, input_html: { rows: 15 }
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