class OrdersController < ApplicationController
	before_filter :authenticate_user!, :only => ['index', 'pay', 'success']
  # GET /orders
  # GET /orders.json
  def index
  	puts "============"
    @orders = current_user.orders

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  def new
  	@job = Job.find_by_name_and_status(params['job_id'], 'done')
  	raise ActiveRecord::RecordNotFound if @job.nil?
    @order = Order.new
    @user = User.new
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
    
  def place
      @job_id=params[:job_id]
  end
    
  def confirm
    if !user_signed_in?
      user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
      begin
        user.save!
      rescue
        # TODO
        # redirect_to orders#place
        redirect_to "/"
      else
        sign_in(:user, user)
      end
    end

    @order = current_user.orders.build(:status => "new")
    order_item = @order.order_items.build(:job_id => params[:job_id], :job_amount => params[:count])

    if !params[:name].blank?
      shipment = current_user.shipments.build(:name => params[:name], :address => params[:address], :phone => params[:phone])
      shipment.save
    else
      shipment = Shipment.find_by_id_and_user_id(params[:id], current_user.id)
    end

    @order.shipment_id = shipment.id
    @order.save

	end
    
	def pay
    m = params["optionsRadios"]

    m = "" if m == 'alipay'
    @url = WebAlipayUtil.construct_auth_and_excute_url("1111", 1, m, "")

		redirect_to @url
	end
	
	def ali_callback
		logger = Logger.new('log/ali_callback.log')
		logger.info(params)		

    if not WebAlipayUtil.sign_valid?(params)
      logger.info("invalid")
      render :nothing => true
      return
    end

    out_trade_no = params["out_trade_no"]
    order_id = out_trade_no[out_trade_no.index(Settings.ORDER_PREFIX) + Settings.ORDER_PREFIX.size, out_trade_no.size - Settings.ORDER_PREFIX.size]

    order = Order.find(order_id)
    order.status = "paid"
    order.save
    render :nothing => true
	end

  def success
    order_id = params[:id]
    order = Order.find_by_id_and_status(order_id, "paid")
  end


end
