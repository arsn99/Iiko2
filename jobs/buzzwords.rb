require "action_view"
include ActionView::Helpers::NumberHelper
class Buzz
	@@points
	@@la
	@@pointsM
	@@laM
	@@pointsKas
	@@laKas
	@@pointsKasM
	@@laKasM
    @@pointsTypeM
	@@laKasTypeM
    @@pointsTypeToday
	@@laKasTypeToday
	def UseBuzz()
		#СПИСОК по типам оплат

		dataBuzz = $iiko.IikoPostRequestToday("POSTforBUZZ.json")
		@@points= []
		@@la = []
        sum = 0
		dataBuzz['data'].each do |iikos|
			  @@points << { sum:iikos['DishDiscountSumInt'] , type: iikos['PayTypes'] }
              sum+=iikos['DishDiscountSumInt']
		end

		@@points = @@points.sort_by { |h| -h[:sum]}
		@@la<<{label:"Тип оплаты",value:"Сум."}
		@@points.each_with_index do |i,k|

			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			@@la<<{label:(k+1).to_s+". "+i[:type],value:str}
		end
        sum = number_with_delimiter(sum.round, delimiter: " ")
        send_event('buzzwords', { items: @@la ,moreinfo:Date.today,sum:sum})

		#СПИСОК по типам оплат за месяц

        sum=0
		dataBuzzMounth = $iiko.IikoPostRequestForSebesMounth("POSTforBUZZ.json","CURRENT_MONTH")
		@@pointsM= []
		@@laM = []

		dataBuzzMounth['data'].each do |iikos|
			  @@pointsM << { sum:iikos['DishDiscountSumInt'] , type: iikos['PayTypes'] }
                sum+=iikos['DishDiscountSumInt']
		end

		@@pointsM = @@pointsM.sort_by { |h| -h[:sum]}
		@@laM<<{label:"Тип оплаты",value:"Сум."}
		@@pointsM.each_with_index do |i,k|
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			@@laM<<{label:(k+1).to_s+". "+i[:type],value:str}
		end
        #######
	       send_event('max', { value: sum, max:1800000,moreinfo:"1 800 000",procent:number_with_delimiter(((sum/1800000)*100).round(2), delimiter: " ").to_s+"%"})
		   keka = []
		   keka<<{'name'=>number_with_delimiter(sum.round, delimiter: " ").to_s + " / "+ number_with_delimiter(1800000, delimiter: " ").to_s,'progress'=>(sum/1800000)*100}
		   keka<<{'name'=>"Тестовый1",'progress'=>29}
		   keka<<{'name'=>"Тестовый2",'progress'=>45}
		   keka<<{'name'=>"Тестовый3",'progress'=>60}
		   keka<<{'name'=>"Тестовый4",'progress'=>77}
		   keka<<{'name'=>"Тестовый5",'progress'=>90}
		   send_event( 'progress_bars', {title: "Выручка", progress_items: keka} )

		  # send_event('telegram', { items: $iiko.TelegramMessage()})
        #######
        sum = number_with_delimiter(sum.round, delimiter: " ")
        send_event('buzzwordsM', { items: @@laM ,moreinfo:Date.today.strftime("%B"),sum:sum})


		# Выручка касс
        sum=0
		dataKas = $iiko.IikoPostRequestToday("ViruchkaKassi.json")
		@@pointsKas= []
		@@laKas = []

		dataKas['data'].each do |iikos|
			  @@pointsKas << { cash:iikos['CashRegisterName'] , sum: iikos['DishDiscountSumInt'] }
              sum+=iikos['DishDiscountSumInt']

		end

		@@pointsKas =@@pointsKas.sort_by { |h| -h[:sum]}


		@@laKas<<{label:"Номер кассы",value:"Сум."}
		@@pointsKas.each_with_index do |i,k|
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			@@laKas<<{label:(k+1).to_s+". "+i[:cash].to_s,value:str}
		end
        sum = number_with_delimiter(sum.round, delimiter: " ")
        send_event('buzzwordsKas', { items: @@laKas,moreinfo:Date.today,sum:sum})
		# Выручка касс МЕСЯЦ
        sum=0
		dataKasM = $iiko.IikoPostRequestForSebesMounth("ViruchkaKassi.json","CURRENT_MONTH")
		@@pointsKasM= []
		@@laKasM = []

		dataKasM['data'].each do |iikos|
			  @@pointsKasM << { cash:iikos['CashRegisterName'] , sum: iikos['DishDiscountSumInt'] }
              sum+= iikos['DishDiscountSumInt']

		end

		@@pointsKasM = @@pointsKasM.sort_by { |h| -h[:sum]}


		@@laKasM<<{label:"Номер кассы",value:"Сум."}
		@@pointsKasM.each_with_index do |i,k|
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			@@laKasM<<{label:(k+1).to_s+". "+i[:cash].to_s,value:str}
		end
        sum = number_with_delimiter(sum.round, delimiter: " ")
		send_event('buzzwordsKasM', { items: @@laKasM ,moreinfo:Date.today.strftime("%B"),sum:sum})

        #По типам скидки МЕСЯЦ
        sum=0
		dataTypeM = $iiko.IikoPostRequestForSebesMounth("PostTypeDiscont.json","CURRENT_MONTH")
		@@pointsTypeM= []
		@@laKasTypeM = []

		dataTypeM['data'].each do |iikos|
            if iikos['OrderDiscount.Type']==""
                next
              end

              if iikos['OrderDiscount.Type'].length < 17
				@@pointsTypeM << { sum:iikos['DiscountSum'] , type: iikos['OrderDiscount.Type'] }
                sum+=iikos['DiscountSum']
			  else
				nameS = ""
				lengthS = iikos['OrderDiscount.Type'].split(" ").length
				i = 0
				iikos['OrderDiscount.Type'].split(" ").each_with_index do |name,k|

					if name.length > 3
						name=name.slice(0..2)+"."
					end
					nameS <<" "+name
				end
				@@pointsTypeM << { sum:iikos['DiscountSum'] , type: nameS }
                sum+=iikos['DiscountSum']
			  end

		end

		@@pointsTypeM = @@pointsTypeM.sort_by { |h| -h[:sum]}


		@@laKasTypeM<<{label:"Тип Скидки",value:"Сум."}
		@@pointsTypeM.each_with_index do |i,k|
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			@@laKasTypeM<<{label:(k+1).to_s+". "+i[:type].to_s,value:str}
		end
        sum = number_with_delimiter(sum.round, delimiter: " ")
		send_event('buzzwordsTypeM', { items: @@laKasTypeM ,moreinfo:Date.today.strftime("%B"),sum:sum})

        #По типам скидки СЕГОДНЯ
        sum=0
		dataTypeToday = $iiko.IikoPostRequestToday("PostTypeDiscontToday.json")
		@@pointsTypeToday= []
		@@laKasTypeToday = []

		dataTypeToday['data'].each do |iikos|

              if iikos['OrderDiscount.Type']==""
                next
              end

              if iikos['OrderDiscount.Type'].length < 17
				@@pointsTypeToday << { sum:iikos['DiscountSum'] , type: iikos['OrderDiscount.Type'] }
                sum+=iikos['DiscountSum']
			  else
				nameS = ""
				lengthS = iikos['OrderDiscount.Type'].split(" ").length
				i = 0
				iikos['OrderDiscount.Type'].split(" ").each_with_index do |name,k|

					if name.length > 3
						name=name.slice(0..2)+"."
					end
					nameS <<" "+name
				end
				@@pointsTypeToday << { sum:iikos['DiscountSum'] , type: nameS }
                sum+=iikos['DiscountSum']
			  end

		end

		@@pointsTypeToday = @@pointsTypeToday.sort_by { |h| -h[:sum]}


		@@laKasTypeToday<<{label:"Тип Скидки",value:"Сум."}
		@@pointsTypeToday.each_with_index do |i,k|
			str = number_with_delimiter(i[:sum].round, delimiter: " ").to_s
			@@laKasTypeToday<<{label:(k+1).to_s+". "+i[:type].to_s,value:str}
		end
        sum = number_with_delimiter(sum.round, delimiter: " ")
		send_event('buzzwordsTypeToday', { items: @@laKasTypeToday ,moreinfo:Date.today.strftime("%B"),sum:sum})

	end
end

buzz = Buzz.new
SCHEDULER.every '15m', :first_in => 0 do |job|
  buzz.UseBuzz()
end
