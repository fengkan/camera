#encoding: utf-8

class WebAlipayUtil

#  WEB_CALL_BACK_URL = Settings["API_SERVER_IP"] + "/alipay/web_callback"
#  WEB_NOTIFY_URL =  Settings["API_SERVER_IP"] + "/alipay/web_notify"

  WEB_NOTIFY_URL =  "#{Settings.HOST}/order/ali_callback"

  def WebAlipayUtil.construct_auth_and_excute_url(order_id,total_fee, bank, callback)
=begin
    response = WebAlipayUtil.alipay_trade_create(order_id,total_fee)
    if response == nil || response.code != 200
      Error.log "alipay_trade_create error: response == nil || response.code != 200"
      return false
    end

    request_token = WebAlipayUtil.get_request_token(response)
    if !request_token
       return false
    end
=end
		puts "==========="
		puts WEB_NOTIFY_URL

    params = {}
    params["service"] = "create_direct_pay_by_user"
#    params["format"] = "xml"
#    params["v"] = "2.0"
    params["partner"] = Settings.ALI_ID
#    params["sec_id"] = "MD5"
    params["_input_charset"] = "utf-8"    
#    params["sign_type"] = "MD5"
    params["notify_url"] = WEB_NOTIFY_URL
		params["return_url"] = WEB_NOTIFY_URL
#		params["return_url"] = callback if callback != nil
params['defaultbank'] = bank if !bank.blank?

    params["out_trade_no"] = "123dcamera_" + order_id.to_s
		params["subject"] = "微米印"
		params["payment_type"] = "1"
		params["seller_id"] = Settings.ALI_ID
#    params["price"] = total_fee.to_s
#    params["quantity"] = 1.to_s
#    params["logistics_type"] = "EMS"
#    params["logistics_fee"] = "0"
#    params["logistics_payment"] = "SELLER_PAY"

    params["total_fee"] = total_fee.to_s


=begin
    req_data = REXML::Document.new
    auth_and_execute_req_node = req_data.add_element("auth_and_execute_req")
    request_token_node = auth_and_execute_req_node.add_element("request_token")
    request_token_node.add_text(request_token)

    out_string = ""
    req_data.write(out_string)

    params["req_data"] = out_string
=end

    query_string =  params.sort.map{|kv| kv[0] + "=" + kv[1]}.join("&")
    sign = Digest::MD5.hexdigest(query_string + Settings.ALI_KEY)

    query_string = query_string + "&sign=" + sign + "&sign_type=MD5"

    return Settings.ALI_GATEWAY + "?"  + URI.encode(query_string)
  end

  def WebAlipayUtil.check_sign(params)
    AlipayLog.log params.to_s
    sign = params.delete("sign")
		sign_type = params.delete("sign_type")
    AlipayLog.log "sign = #{sign}"

    query_string =  params.sort.map{|kv| kv[0] + "=" + kv[1]}.join("&")
    sign = Digest::MD5.hexdigest(query_string + Settings.ALI_KEY)

=begin
    query_string = "service=" + params["service"]
    query_string = query_string + "&" + "v=" + params["v"]
    query_string = query_string + "&" + "sec_id=" + params["sec_id"]
    query_string = query_string + "&" + "notify_data=" + params["notify_data"]
=end

    if sign != Digest::MD5.hexdigest(query_string + Settings.ALI_KEY)
      AlipayLog.log "alipay call back: check sign error"
      return false
    end

    return true
  end

end

