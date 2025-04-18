ActiveAdmin.register Province do
  # Define permitted parameters
  permit_params :name, :code, :gst_rate, :pst_rate, :hst_rate

  # Configure the index page
  index do
    selectable_column
    id_column
    column :name
    column :code
    column :gst_rate, sortable: true do |province|
      "#{province.gst_rate}%"
    end
    column :pst_rate, sortable: true do |province|
      "#{province.pst_rate}%"
    end
    column :hst_rate, sortable: true do |province|
      "#{province.hst_rate}%"
    end
    actions
  end

  # Define the filters in the sidebar
  filter :name
  filter :code
  filter :gst_rate
  filter :pst_rate
  filter :hst_rate

  # Configure the show page
  show do
    attributes_table do
      row :id
      row :name
      row :code
      row :gst_rate do |province|
        "#{province.gst_rate}%"
      end
      row :pst_rate do |province|
        "#{province.pst_rate}%"
      end
      row :hst_rate do |province|
        "#{province.hst_rate}%"
      end
      row :created_at
      row :updated_at
    end
  end

  # Configure the form
  form do |f|
    f.inputs 'Province Details' do
      f.input :name
      f.input :code
      f.input :gst_rate, label: 'GST Rate (%)'
      f.input :pst_rate, label: 'PST Rate (%)'
      f.input :hst_rate, label: 'HST Rate (%)'
    end
    f.actions
  end
end