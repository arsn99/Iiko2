
class Pie
	@@pointsPie= []
	@@labelsPie = []
	@@DishDiscountSumIntPie = []
	def PieF()
		@@pointsPie.shift(@@pointsPie.length)
		@@labelsPie.shift(@@labelsPie.length)
		@@DishDiscountSumIntPie.shift(@@DishDiscountSumIntPie.length)
		# Типы оплат
		data = $iiko.IikoPostRequestForSebesMounth("POSTforBUZZ.json","CURRENT_MONTH")

		#labels = ['January', 'February', 'March', 'April', 'May', 'June', 'July','Aug']


		data['data'].each do |iikos|
			  @@pointsPie << { type:iikos['PayTypes'] , sum: iikos['DishDiscountSumInt'] }

		end
		@@pointsPie = @@pointsPie.sort_by { |h| -h[:sum]}

		@@pointsPie.each do |i|
            if i[:sum] != 0
                @@DishDiscountSumIntPie<<i[:sum]
                @@labelsPie<<i[:type]+" : "+ number_with_delimiter(i[:sum].round, delimiter: " ").to_s
            end

		end
		dataMoreInfoSum =  number_with_delimiter(data['summary'][1][1]['DishDiscountSumInt'].round, delimiter: " ")
		data = [
			{
			  # Create a random set of data for the chart
			  data: @@DishDiscountSumIntPie ,
			  backgroundColor: [
				'#F7464A',
				'#46BFBD',
				'#FDB45C',
				'#FFC000',
				'#FFCE56',
				'#000E56',
				'#FFCE56',
				'#CCCEC6',
				'#CC000E',
				'#CCFFFE',
				'#FCBEDE'
			  ],
			  hoverBackgroundColor: [
				'#FF6384',
				'#36A2EB',
				'#F00056',
				'#FFC000',
				'#FFCE56',
				'#000E56',
				'#FFCE56',
				'#CCCEC6',
				'#CC000E',
				'#CCFFFE',
				'#FCBEDE'
			  ],
			},
		  ]
		  send_event('piechart', { labels: @@labelsPie, datasets: data ,moreinfo:dataMoreInfoSum})
	end
end
pie = Pie.new
SCHEDULER.every '15m', :first_in => 0 do |job|
	pie.PieF()

end
