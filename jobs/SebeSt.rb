class Sebes
	def UseSebes()
		# себе стоимость сегодня вчера
		filterDeleted = {"DeletedWithWriteoff" => {"filterType"=> "IncludeValues",
                                           "values"=>["NOT_DELETED"]  } }

		#dataSebes = $iiko.IikoPostRequestForSebesToday("PostForSebesToday.json")
		dataSebes = $iiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["ProductCostBase.ProductCost"], str: "TODAY_YESTERDAY",filters: filterDeleted)
		if dataSebes['data'].blank?
			dataSebes['data']<<{'ProductCostBase.ProductCost'=> 0}
			dataSebes['data']<<{'ProductCostBase.ProductCost'=> 0}
		else
			if dataSebes['data'][1].blank?
				if  !dataSebes['data'][0]['OpenDate.Typed'].blank? & dataSebes['data'][0]['OpenDate.Typed'] == Date.today.strftime("%Y-%m-%d")
					dataSebes['data']<<{'ProductCostBase.ProductCost'=> dataSebes['data'][0]['ProductCostBase.ProductCost']}
					dataSebes['data'][0]['ProductCostBase.ProductCost']=0
				else
					dataSebes['data']<<{'ProductCostBase.ProductCost'=> 0}

				end
			end
		end

		
		# себе стоимость %%% сегодня вчера
		#dataSebesPrecent = $iiko.IikoPostRequestForSebesToday("PostForSebes%.json")
		dataSebesPrecent = $iiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["ProductCostBase.Percent"], str: "TODAY_YESTERDAY",filters: filterDeleted)

		if dataSebesPrecent['data'].blank?
			dataSebesPrecent['data']<<{'ProductCostBase.Percent'=> 0}
			dataSebesPrecent['data']<<{'ProductCostBase.Percent'=> 0}
		else
			if dataSebesPrecent['data'][1].blank?
				if  dataSebesPrecent['data'][0]['OpenDate.Typed'] == Date.today.strftime("%Y-%m-%d")
					dataSebesPrecent['data']<<{'ProductCostBase.Percent'=> dataSebesPrecent['data'][0]['ProductCostBase.Percent']}
					dataSebesPrecent['data'][0]['ProductCostBase.Percent']=0
				else
					dataSebesPrecent['data']<<{'ProductCostBase.Percent'=> 0}
				end
			end
		end

		
		# Кол-во заказов сегодня вчера
		#dataZakaz = $iiko.IikoPostRequestForSebesToday("PostZakazovToday.json")
		dataZakaz = $iiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["UniqOrderId.OrdersCount"], str: "TODAY_YESTERDAY")

		if dataZakaz['data'].blank?
			dataZakaz['data']<<{'UniqOrderId.OrdersCount'=> 0}
			dataZakaz['data']<<{'UniqOrderId.OrdersCount'=> 0}
		else
			if dataZakaz['data'][1].blank?
				if  dataZakaz['data'][0]['OpenDate.Typed'] == Date.today.strftime("%Y-%m-%d")
					dataZakaz['data']<<{'UniqOrderId.OrdersCount'=> dataZakaz['data'][0]['UniqOrderId.OrdersCount']}
					dataZakaz['data'][0]['UniqOrderId.OrdersCount']=0
				else
					dataZakaz['data']<<{'UniqOrderId.OrdersCount'=> 0}
				end
			end
		end

		

        # Себес + сумма + процент
        #dataMulti = $iiko.IikoPostRequestToday("SumWithSebes.json")
        dataMulti = $iiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["ProductCostBase.ProductCost","DishDiscountSumInt","ProductCostBase.Percent"], str: "TODAY",filters: filterDeleted)
        if dataMulti['data'].blank?
        	dataMulti['data']<<{'ProductCostBase.ProductCost'=> 0,'DishDiscountSumInt'=> 0,'ProductCostBase.Percent'=> 0}
        end

        
      
        #dataMultiM= $iiko.IikoPostRequestForSebesMounth("SumWithSebesM.json","CURRENT_MONTH")
        dataMultiM = $iiko.IikoPostRequestSTR(groupByColFields: ["Mounth"],aggregateFields: ["ProductCostBase.ProductCost","DishDiscountSumInt","ProductCostBase.Percent"], str: "CURRENT_MONTH",filters: filterDeleted)


        #Средн. сумма заказа
        #dataSrCheck = $iiko.IikoPostRequestForSebesToday("SrCheck.json")
        dataSrCheck = $iiko.IikoPostRequestSTR(groupByColFields: ["OpenDate.Typed"],aggregateFields: ["DishDiscountSumInt.average"], str: "TODAY_YESTERDAY")

        if dataSrCheck['data'].blank?
			dataSrCheck['data']<<{'DishDiscountSumInt.average'=> 0}
			dataSrCheck['data']<<{'DishDiscountSumInt.average'=> 0}
		else
			if dataSrCheck['data'][1].blank?
				if  dataSrCheck['data'][0]['OpenDate.Typed'] == Date.today.strftime("%Y-%m-%d")
					dataSrCheck['data']<<{'DishDiscountSumInt.average'=> dataSrCheck['data'][0]['DishDiscountSumInt.average']}
					dataSrCheck['data'][0]['DishDiscountSumInt.average']=0
				else
					dataSrCheck['data']<<{'DishDiscountSumInt.average'=> 0}
				end
			end
		end
		

        #dataSrCheckM = $iiko.IikoPostRequestForSebesMounth("SrCheckM.json","CUSTOM")
        dataSrCheckM = $iiko.IikoPostRequestSTR(groupByColFields: ["Mounth"],aggregateFields: ["DishDiscountSumInt.average"], str: "CUSTOM")

		########################################################################

		# себе стоимость месяц
		#dataSebesMounth = $iiko.IikoPostRequestForSebesMounth("PostForSebesMounth.json","CUSTOM")
        dataSebesMounth = $iiko.IikoPostRequestSTR(groupByColFields: ["Mounth"],aggregateFields: ["ProductCostBase.ProductCost"], str: "CUSTOM",filters: filterDeleted)


		# себе стоимость месяц
		#dataSebesMounthPrecent = $iiko.IikoPostRequestForSebesMounth("PostForSebesM%.json","CUSTOM")
        dataSebesMounthPrecent = $iiko.IikoPostRequestSTR(groupByColFields: ["Mounth"],aggregateFields: ["ProductCostBase.Percent"], str: "CUSTOM",filters: filterDeleted)

		# Кол-во заказов месяц
		#dataZakazMounth = $iiko.IikoPostRequestForSebesMounth("PostZakazovMounth.json","CUSTOM")
        dataZakazMounth = $iiko.IikoPostRequestSTR(groupByColFields: ["Mounth"],aggregateFields: ["UniqOrderId.OrdersCount"], str: "CUSTOM")

		today = dataSebes['data'][1]['ProductCostBase.ProductCost']
		yesterday = dataSebes['data'][0]['ProductCostBase.ProductCost']
	  send_event('dataSebes', { current: today, last: yesterday,moreinfo:yesterday})

	  today = dataZakaz['data'][1]['UniqOrderId.OrdersCount']
	  yesterday = dataZakaz['data'][0]['UniqOrderId.OrdersCount']
	  send_event('dataZakaz', { current: today, last: yesterday,moreinfo:yesterday})

	  today = (dataSebesPrecent['data'][1]['ProductCostBase.Percent']*100).round(2)
	  yesterday = (dataSebesPrecent['data'][0]['ProductCostBase.Percent']*100).round(2)
	  send_event('dataSebesPrecent', { current: today, last: yesterday,moreinfo:yesterday})

      today = (dataSrCheckM['data'][1]['DishDiscountSumInt.average']).round(2)
	  yesterday = (dataSrCheckM['data'][0]['DishDiscountSumInt.average']).round(2)
	  send_event('SrCheckM', { current: today, last: yesterday,moreinfo:yesterday})

      today = (dataSrCheck['data'][1]['DishDiscountSumInt.average']).round(2)
	  yesterday = (dataSrCheck['data'][0]['DishDiscountSumInt.average']).round(2)
	  send_event('SrCheck', { current: today, last: yesterday,moreinfo:yesterday})

      high = (dataMultiM['data'][0]['ProductCostBase.ProductCost']).round(2)
	  middle = (dataMultiM['data'][0]['ProductCostBase.Percent']*100).round(2)
	  low = (dataMultiM['data'][0]['DishDiscountSumInt']).round(2)

	  send_event('MultiM', { high: high, middle: middle.to_s+" %",low:low})

      high = (dataMulti['data'][0]['ProductCostBase.ProductCost']).round(2)
	  middle = (dataMulti['data'][0]['ProductCostBase.Percent']*100).round(2)
	  low = (dataMulti['data'][0]['DishDiscountSumInt']).round(2)

	  send_event('Multi', { high: high, middle: middle.to_s+" %",low:low})

	  today = dataSebesMounth['data'][1]['ProductCostBase.ProductCost']
	  yesterday = dataSebesMounth['data'][0]['ProductCostBase.ProductCost']
	  send_event('dataSebesM', { current: today, last: yesterday,moreinfo:yesterday})

	  today = dataZakazMounth['data'][1]['UniqOrderId.OrdersCount']
	  yesterday = dataZakazMounth['data'][0]['UniqOrderId.OrdersCount']
	  send_event('dataZakazM', { current: today, last: yesterday,moreinfo:yesterday})

	  today = (dataSebesMounthPrecent['data'][1]['ProductCostBase.Percent']*100).round(2)
	  yesterday = (dataSebesMounthPrecent['data'][0]['ProductCostBase.Percent']*100).round(2)
	  send_event('dataSebesMounthPrecent', { current: today, last: yesterday,moreinfo:yesterday})

	end

end

sebes = Sebes.new

SCHEDULER.every '15m', :first_in => 5 do |job|

sebes.UseSebes()


end
