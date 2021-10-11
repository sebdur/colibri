class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.where(user: current_user).where(payed: true)
    @payments = Payment.where(user: current_user, orders: @orders)
  end

  # POST /orders
  # POST /orders.json
  def create
    @orders = Order.where(user: current_user).where(payed: false)
    @stock = Stock.find(params[:order][:stock_id])
    @payment = Payment.find_or_create_by(user: current_user, token: nil)
    @order = Order.find_or_create_by(user: current_user, payed: false, stock: @stock, payment: @payment)
    if (@order.quantity + params[:order][:quantity].to_i) <= @order.stock.stock_quantity
      @order.quantity += params[:order][:quantity].to_i
    else
      @order.quantity = @order.stock.stock_quantity
    end
    if @order.save
      respond_to :js
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    respond_to :js
    @orders = Order.where(user: current_user).where(payed: false)
    @order = Order.find(params[:id])
    @order.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:payed, :pay_way, :pay_date, :user_id, :stock_id, :quantity)
  end
end
