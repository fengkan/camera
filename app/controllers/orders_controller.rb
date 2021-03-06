#encoding: utf-8

class OrdersController < ApplicationController
	before_filter :login_required, :only => [:index]

  # GET /orders
  # GET /orders.json
  def index
    @orders = current_user.orders

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find_by_md5(params[:id])
    
    if @order.nil?
    	if logged_in?
	    	@order = Order.find_by_id_and_user_id(params[:id], current_user.id)
    	else
    		store_location
    		authenticate_user!
  		end
  	end
  	
  	@job = Job.find(@order.order_items[0].job_id)

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
    @job_id = params[:job_id]
    @job = Job.find_by_name(@job_id)
    if @job
      @job_style = 0
      @shipments = current_user.shipments if logged_in?
    else
      redirect_to '/job/show'
    end
  end
    
  def confirm
  	job_style = 0
  	
  	if !params[:id].blank?
  		@order = Order.find_by_md5(params[:id])
  		if @order.status != "new"
  			redirect_to :action => :show, :id => params[:id]
			end
		else
	    if !logged_in?
	      user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
	      begin
	        user.save!
	      rescue
		  		flash[:alert] = "该 Email 已存在，请登入或者选择其他 Email"
	        redirect_to :controller => :orders, :action => :place, :job_id => params[:job_id]
	        return
	      else
	      	self.current_user = user
	      end
	    end
	
	    @order = current_user.orders.build(:status => "new")
	    @job = Job.find_by_name(params[:job_id])
	    order_item = @order.order_items.build(:job_id => @job.id, :job_amount => params[:count], :job_style => job_style, :price => params[:count].to_i * Settings.PRODUCTS[job_style]["product_price"].to_f)
	
	    if !params[:name].blank?
	      shipment = current_user.shipments.build(:name => params[:name], :address => params[:address], :phone => params[:phone])
	      shipment.save
	    else
	      shipment = Shipment.find_by_id_and_user_id(params[:shipment_id], current_user.id)
	    end
	
	    @order.shipment_id = shipment.id
	    @order.save
    end
	end
    
	def pay
		id = params[:order_id]
		order = Order.find_by_md5_and_status(id, "new")
		
#		callback = Settings.HOST + "/orders/close/#{order.md5}"

    m = params["optionsRadios"]
    m = "" if m == 'alipay'
    @url = WebAlipayUtil.construct_auth_and_excute_url(Settings.PRODUCTS[0]["product_name"], order.id, order.total_price, m)
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
    
    Resque.enqueue(OrderNotification, "paid_notification", order.id)
    render :nothing => true
	end

  def close
    order_id = params[:id]
    @order = Order.find_by_md5(order_id)
    if @order.nil?
    	render :action => :failed
  	elsif @order.status == "new"
  		flash[:alert] = "付款未能成功，请重试！"
  		redirect_to :action => :confirm, :id => order_id
		elsif @order.status != "paid"
    	render :action => :failed
  	end
  end


end
