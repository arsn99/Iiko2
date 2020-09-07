class Convergence
	@@pointsCon
	
	def UseConverg()
		data = $iiko.IikoPostRequest()
		@@pointsCon= []
		data['data'].each_with_index do |iikos,k|
				@@pointsCon << { :x =>  Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").to_time.to_i, :y => iikos['DishDiscountSumInt.average'] }	
				
		end
		series = [
		{
			name: Date.today.prev_year.strftime("%Y").to_s,
			data: @@pointsCon
		}
		]

		
	   send_event('month_co_requests', series: series, displayedValue: 0 )
	end

end
conv = Convergence.new

SCHEDULER.every '15m', :first_in => 0 do |job|
	conv.UseConverg()
end