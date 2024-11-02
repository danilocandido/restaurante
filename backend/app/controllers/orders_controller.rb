class OrdersController < ApplicationController
  before_action :set_order, only: %i[in_progress finished]

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = Order.new(table_id: order_params[:table_id])
    @order.items.build(order_params[:items])

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def in_progress
    return head :not_modified if @order.in_progress?

    @order.in_progress!
    OrderNotifier.send(:kitchen, @order)
    render json: @order, status: :accepted
  end

  def finished
    return head :not_modified if @order.finished?

    @order.finished!
    OrderNotifier.send(:waiter, @order)
    render json: @order, status: :accepted
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy!
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:table_id, :items => %i[product_id amount])
  end
end
