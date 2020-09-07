module Iiko

require 'net/http'
require 'uri'
require 'digest/sha1'
require 'json'


 class IikoRequests
	
	$delete = true
	$iikoResponseToken = ""
	def initialization(login = 'admin',password = 'Cnhtc101%')
		@login=login
		@password=Digest::SHA1.hexdigest password
		@url = URI.parse("https://myusli.iiko.it:443/resto/api/")
		
		#puts "login = #{@login}\npassword = #{@password}"
	end
	
	def GetToken()
	
		if $iikoResponseToken == ""
			initialization()
		  params = {
			'login':@login,
			'pass':@password
			}
			url = @url+"auth"
			url.query = URI.encode_www_form( params )	
		
			$iikoResponseToken = Net::HTTP.get(url).to_s
			
			File.open("log.txt","a") do |log|
				log.print("Токен получен : #{$iikoResponseToken}\t\t#{Time.now}\n")
			end
	
		end
		#puts $iikoResponseToken
	end
	
	def Finalize()
		puts "FINAL"
			params = {
				'key':$iikoResponseToken		
			}
			url = @url + "logout"
			url.query = URI.encode_www_form( params )	
			Net::HTTP.get(url)
			
			File.open("log.txt","a") do |log|
				log.print("Токен удален : #{$iikoResponseToken}\t\t#{Time.now}\n")	
			end			
	end
	
	def IikoPostRequest(jsonFile)
	
		lines=""
		File.open(jsonFile) do |jsons|
			lines = JSON.load(jsons)
			
		end
		lines['filters']['OpenDate.Typed']['from'] = Date.today.prev_month.strftime("%Y-%m-%d")#ВРЕМЕННО убрать prev
		lines['filters']['OpenDate.Typed']['to']   = Date.today.strftime("%Y-%m-%d")
		url = URI("https://myusli.iiko.it:443/resto/api/v2/reports/olap")
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		request = Net::HTTP::Post.new(url)
		request["Content-Type"] = "application/json"
		request["Cookie"] = "key=#{$iikoResponseToken}"
		request.body = lines.to_json	
		response = http.request(request)
		@data = JSON.parse(response.read_body)		
		return @data
	
	end	
	
	def IikoPostRequestForBuzz()
		begin  
			lines=""
			File.open("POSTforBUZZ.json") do |jsons|
				lines = JSON.load(jsons)
				
			end
			url = URI("https://myusli.iiko.it:443/resto/api/v2/reports/olap")
			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = true
			request = Net::HTTP::Post.new(url)
			
			request["Content-Type"] = "application/json"
			request["Cookie"] = "key=#{$iikoResponseToken}"
			request.body = lines.to_json
			
			response = http.request(request)
			
			
			@data = JSON.parse(response.read_body)	
			return @data
		rescue # optionally: `rescue Exception => ex`
			Finalize()
		end 
	
	end	
	def IikoPostRequestToday(jsonFile)
	# ДОБАВИТЬ ВОЗМОЖНОСТЬ ИЗМЕНЯТЬ ДАТУ НА ТЕКУЩУЮ----------------------------------------------
		lines=""
		File.open(jsonFile) do |jsons|
			lines = JSON.load(jsons)
			
		end
		lines['filters']['OpenDate.Typed']['from'] = Date.today.strftime("%Y-%m-%d")#ВРЕМЕННО убрать prev
		lines['filters']['OpenDate.Typed']['to']   = Date.today.strftime("%Y-%m-%d")	 #ВРЕМЕННО
		url = URI("https://myusli.iiko.it:443/resto/api/v2/reports/olap")
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		request = Net::HTTP::Post.new(url)
		request["Content-Type"] = "application/json"
		request["Cookie"] = "key=#{$iikoResponseToken}"
		request.body = lines.to_json	
		response = http.request(request)
		@data = JSON.parse(response.read_body)		
		return @data
	
	end	
 
	def IikoPostRequestForSebesToday(jsonFile)
		begin
			lines=""
			File.open(jsonFile) do |jsons|
				lines = JSON.load(jsons)
			end
			lines['filters']['OpenDate.Typed']['from'] = Date.today.prev_day.strftime("%Y-%m-%d")#Вернуть prev_day
			lines['filters']['OpenDate.Typed']['to'] =   Date.today.strftime("%Y-%m-%d")
			#puts "keka",Date.today.strftime("%Y-%m-%d")
			#puts lines
			
			url = URI("https://myusli.iiko.it:443/resto/api/v2/reports/olap")
			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = true
			request = Net::HTTP::Post.new(url)
			request["Content-Type"] = "application/json"
			request["Cookie"] = "key=#{$iikoResponseToken}"
			request.body = lines.to_json	
			response = http.request(request)
			@data = JSON.parse(response.read_body)		
			return @data
		rescue
			Finalize()
		end
	
	end	
	def CheckToken()
		
		params = {
			'key':$iikoResponseToken,
			'reportType':'SALES'
			}
			url = @url + "v2/reports/olap/columns"
			url.query = URI.encode_www_form( params )	
			http = Net::HTTP.new(url.host, url.port)
			http.use_ssl = true
			request = Net::HTTP::Get.new(url)
			res = http.request(request)
			puts res.code
			if res.code!="200"
				puts res.code
				$iikoResponseToken=""
				puts "Получаем токен #{Time.now}"
				GetToken()
			end
	end
	def IikoPostRequestForSebesMounth(jsonFile,str)#[CUSTOM, OPEN_PERIOD, TODAY, YESTERDAY, CURRENT_WEEK, CURRENT_MONTH, CURRENT_YEAR, LAST_WEEK, LAST_MONTH, LAST_YEAR]
	
		lines=""
		File.open(jsonFile) do |jsons|
			lines = JSON.load(jsons)
		end
		
		lines['filters']['OpenDate.Typed']['periodType'] = str
		if str == "CUSTOM" 
			lines['filters']['OpenDate.Typed']['from'] = Date.today.prev_month.strftime("%Y-%m")+"-01"
			lines['filters']['OpenDate.Typed']['to']   = Date.today.strftime("%Y-%m-%d")
		end
		#puts "keka",Date.today.strftime("%Y-%m-%d")
		
		url = URI("https://myusli.iiko.it:443/resto/api/v2/reports/olap")
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		request = Net::HTTP::Post.new(url)
		request["Content-Type"] = "application/json"
		request["Cookie"] = "key=#{$iikoResponseToken}"
		request.body = lines.to_json	
		response = http.request(request)
		@data = JSON.parse(response.read_body)		
		return @data
	
	end
	
	def TelegramMessage
		
		botName = "1074549219:AAED9jl8CEJxv_N1RJfJB57jDDU8aL41Fj4"
		url = URI("https://api.telegram.org/bot#{botName}/getUpdates")
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		request = Net::HTTP::Post.new(url)
		request["Content-Type"] = "application/json"

		response = http.request(request)
		@data = JSON.parse(response.read_body)	
		data = []
		count = 0
		@data['result'].reverse_each do |i|
			if count>5
				break;
			end
			if !(i['channel_post'].nil?)
				data<<{label:i['channel_post']['text'],value:""}
				count+=1
			end
		end
		return data
	end


end

end