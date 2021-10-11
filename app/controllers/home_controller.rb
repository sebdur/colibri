class HomeController < ApplicationController
  skip_authorization_check
  def index
    @products = Product.all
    @categories = Category.all
    @order = Order.new
    if current_user.present?
      @orders = Order.where(user: current_user).where(payed: false)
    end
  end
end
