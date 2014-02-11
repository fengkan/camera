#encoding: utf-8

class WebAlipayUtil
  WEB_NOTIFY_URL =  "#{Settings.HOST}/orders/ali_callback"

  def WebAlipayUtil.construct_auth_and_excute_url(order_id, total_fee, bank, callback = "")
    params = {}
    params["service"] = "create_direct_pay_by_user"
    params["partner"] = SEN_SETTINGS["ALI_ID"]
    params["_input_charset"] = "utf-8"    
    params["notify_url"] = WEB_NOTIFY_URL
		params["return_url"] = callback if !callback.blank?
		params['defaultbank'] = bank if !bank.blank?

    params["out_trade_no"] = Settings.ORDER_PREFIX + order_id.to_s
		params["subject"] = "123D相机"
		params["payment_type"] = "1"
		params["seller_id"] = SEN_SETTINGS["ALI_ID"]
    params["total_fee"] = total_fee.to_s

    query_string =  params.sort.map{|kv| kv[0] + "=" + kv[1]}.join("&")
    sign = Digest::MD5.hexdigest(query_string + SEN_SETTINGS["ALI_KEY"])
    query_string = query_string + "&sign=" + sign + "&sign_type=MD5"

    return SEN_SETTINGS["ALI_GATEWAY"] + "?"  + URI.encode(query_string)
  end

  def WebAlipayUtil.sign_valid?(params)
    sign_param = params.delete("sign")
		remove = params.delete("sign_type")
    remove = params.delete("action")
    remove = params.delete("controller")

    query_string =  params.sort.map{|kv| kv[0] + "=" + kv[1]}.join("&")
    sign_cal = Digest::MD5.hexdigest(query_string + SEN_SETTINGS["ALI_KEY"])

    return sign_cal == sign_param
  end
  
end
