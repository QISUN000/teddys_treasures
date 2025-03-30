
  class AddressesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_address, only: [:edit, :update, :destroy]
    
    def new
      @address = current_user.addresses.build
      @provinces = Province.all
    end
    
    def create
      @address = current_user.addresses.build(address_params)
      
      if @address.save
        redirect_to profile_path, notice: 'Address added successfully.'
      else
        @provinces = Province.all
        render :new
      end
    end
    
    def edit
      @provinces = Province.all
    end
    
    def update
      if @address.update(address_params)
        redirect_to profile_path, notice: 'Address updated successfully.'
      else
        @provinces = Province.all
        render :edit
      end
    end
    
    def destroy
      @address.destroy
      redirect_to profile_path, notice: 'Address removed.'
    end
    
    private
    
    def set_address
      @address = current_user.addresses.find(params[:id])
    end
    
    def address_params
      params.require(:address).permit(:street, :city, :postal_code, :province_id)
    end
  end 
