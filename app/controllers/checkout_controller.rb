class CheckoutController < ApplicationController
  skip_authorization_check
  def redirect_flow
    respond_to :js
    @current_orders = current_user.orders.where(payed: false)
    @current_orders.each do |order|
      if params[:shipping_type_id] === '1'
        order.payment.update(shipping: 'pick-up')
        create_payment
      elsif params[:shipping_type_id] === '2'
        order.payment.update(shipping: 'delivery')
        @address = Address.new
        @regions = Address.regions
        @communes = Address.communes.map{ |commune| commune[0] }
        @last_order = current_user.orders.where(payed: false).last
        render :address_form and return
      end
    end
  end

  def address
    respond_to :js
    @current_orders = current_user.orders.where(payed: false)
    @current_orders.each do |order|
      if order.payment.address.nil?
        Address.create(address_params)
      else
        order.payment.address.update(address_params)
      end
    end
    # if params[:coupon_checkbox] = true
    #   @coupons = Coupon.all
    #   @coupons.each do |coupon|
    #     if params[:coupon_input] === coupon.code
    #       commune_price = 0
    #       shipping_price = commune_price
    #     end
    #   end
    # end
    if address_params["region"] == "RM"
      commune = address_params["commune"]
      commune_price = Address.communes.select{ |e| e.include?(commune) }[0][1].to_i
      shipping_price = commune_price
    end
    create_payment(shipping_price)
  end

  def create_payment(shipping_price = nil)
    require 'mercadopago'
    base_url = Rails.application.credentials.base_url
    sdk = Mercadopago::SDK.new(Rails.application.credentials.mercadopago[:access_token])
    @items = []
    @current_orders.each do |order|
      item = {
        title: order.stock.product.name,
        description: order.stock.product.description,
        unit_price: order.stock.price,
        currency_id: 'CLP',
        quantity: order.quantity
      }
      @items << item
    end
    preference_data = {
      items: @items,
      back_urls: {
        success: base_url.to_s+'/checkout/success',
        failure: base_url.to_s+'/checkout/failure',
        pending: base_url.to_s+'/checkout/pending'
      },
      auto_return: 'approved'
    }
    if shipping_price.present?
      preference_data[:shipments] = {
        "cost": shipping_price,
        "mode": "not_specified"
      }
    end
    preference_response = sdk.preference.create(preference_data)
    preference = preference_response[:response]
    @preference_id = preference['id']
  end

  def success
    # ID del pago de Mercado Pago.
    #params["payment_id"]
    # Estado del pago. Por ejemplo: approved para un pago aprobado o pending para un pago pendiente.
    #params["status"]
    # Valor que hayas enviado a la hora de crear la preferencia de pago.
    #params["external_reference"]
    # ID de la orden de pago generada en Mercado Pago.
    #params["merchant_order_id"]
    # Creación del pago
    #@payment =  Payment.create(amount: 1000, token: params["payment_id"], payment_method: "mercadopago", user_id: current_user.id)
    amount = 0
    @current_orders = current_user.orders.where(payed: false)
    @current_orders.each do |order|
      if order.stock.stock_quantity > 0
        new_stock = order.stock.stock_quantity - order.quantity
        order.stock.update(stock_quantity: new_stock)
        if new_stock == 0
          order.stock.update(enabled: false)
        end
        amount += (order.quantity * order.stock.price)
        order.payed = true
        order.pay_way = 'Mercadopago'
        order.pay_date = Time.now
        order.payment.update(token: params["payment_id"],
                             payment_method: params["payment_type"],
                             amount: amount,
                             status: params["status"],
                             merchant_order_id: params["merchant_order_id"],
                             external_reference: params["external_reference"])
        order.save
      end
    end
    @payment = Payment.find_by(token: params["payment_id"], status: params["status"])
    if @payment.shipping === "delivery"
      @address = @payment.address
      if @address.region == 'RM'
        commune = @address.commune
        @commune_price = Address.communes.select{ |e| e.include?(commune) }[0][1].to_i
        @payment.update(amount: @payment.amount + @commune_price)
      end
    end
  end

  def failure
  end

  def pending
    amount = 0
    @current_orders = current_user.orders.where(payed: false)
    @current_orders.each do |order|
      if order.stock.stock_quantity > 0
        new_stock = order.stock.stock_quantity - order.quantity
        order.stock.update(stock_quantity: new_stock)
        if new_stock == 0
          order.stock.update(enabled: false)
        end
        amount += (order.quantity * order.stock.price)
        order.payed = true
        order.pay_way = 'Mercadopago'
        order.pay_date = Time.now
        order.payment.update(token: params["payment_id"],
                             payment_method: params["payment_type"],
                             amount: amount,
                             status: params["status"],
                             merchant_order_id: params["merchant_order_id"],
                             external_reference: params["external_reference"])
        order.save
      end
    end
    @payment = Payment.find_by(token: params["payment_id"], status: params["status"])
    if @payment.shipping === "delivery"
      @address = @payment.address
      if @address.region == 'RM'
        commune = @address.commune
        @commune_price = Address.communes.select{ |e| e.include?(commune) }[0][1].to_i
        @payment.update(amount: @payment.amount + @commune_price)
      end
    end
  end

  def address_params
    params.require(:address).permit(:street, :street2, :phone ,:region, :commune, :note, :payment_id)
  end
end
