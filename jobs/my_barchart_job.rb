require "action_view"
include ActionView::Helpers::NumberHelper
class Bar

    @@points= []
    @@labelsBar = []
    @@DishDiscountSumInts = []

    @@pointsSr= []
    @@labelsBarSr = []
    @@DishDiscountSumIntsSr = []

    @@pointsSum= []
    @@labelsBarSum = []
    @@DishDiscountSumIntsSum = []

    @@pointsSum2= []
    @@labelsBarSum2 = []
    @@DishDiscountSumIntsSum2 = []

	@@pointsSebesSum= []
    @@labelsBarSebesSum = []
    @@SebesSum = []


    def UseBar()

		 #ГрафикСебест%
        @@pointsSebesSum.shift(@@pointsSebesSum.length)
        @@labelsBarSebesSum.shift(@@labelsBarSebesSum.length)
        @@SebesSum.shift(@@SebesSum.length)

        data = $iiko.IikoPostRequestForSebesMounth("PostForSebes%.json","CURRENT_MONTH")
        prev = ""
        sum = 0
		countDay = 0
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                sum+=(iikos['ProductCostBase.Percent']*100).round(2)
                @@pointsSebesSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sum }
				countDay+=1

              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    @@pointsSebesSum << { x: prev.next_day.strftime('%d-%m') , y: sum/countDay }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                 sum+=(iikos['ProductCostBase.Percent']*100).round(2)
				countDay+=1
                @@pointsSebesSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sum/countDay }

              else
                sum+=(iikos['ProductCostBase.Percent']*100).round(2)
				countDay+=1
                @@pointsSebesSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sum/countDay }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")

              end
        end

        @@pointsSebesSum.each do |i|
            @@SebesSum<<i[:y]
        end

        @@pointsSebesSum.each do |i|
            @@labelsBarSebesSum<<i[:x]
        end

		data = [
            {
              label: 'Себест %',
              data: @@pointsSebesSum,
              backgroundColor: [ 'rgba(128, 128, 90,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * @@labelsBarSebesSum.length,
              borderWidth: 1,

            }
        ]
        send_event('barchartSebes', { labels: @@labelsBarSebesSum, datasets: data })
         #График НАКОПЛЕНИЕ ВЫРУЧКИ
        @@pointsSum.shift(@@pointsSum.length)
        @@labelsBarSum.shift(@@labelsBarSum.length)
        @@DishDiscountSumIntsSum.shift(@@DishDiscountSumIntsSum.length)

        @@pointsSum2.shift(@@pointsSum2.length)
        @@labelsBarSum2.shift(@@labelsBarSum2.length)
        @@DishDiscountSumIntsSum2.shift(@@DishDiscountSumIntsSum2.length)
        #ПЕРВАЯ ЧАСТЬ
        data = $iiko.IikoPostRequestForSebesMounth("POST.json","LAST_MONTH")
        prev = ""
        sumLast=0
        sumCurrent=0
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                sumLast+=iikos['DishDiscountSumInt']
                @@pointsSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumLast }

              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    @@pointsSum << { x: prev.next_day.strftime('%d-%m') , y: sumLast }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                 sumLast+=iikos['DishDiscountSumInt']
                @@pointsSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumLast }
              else
                sumLast+=iikos['DishDiscountSumInt']
                @@pointsSum << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumLast }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
              #@@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
        end

        @@pointsSum.each do |i|
            @@DishDiscountSumIntsSum<<i[:y]
        end

        @@pointsSum.each do |i|
            @@labelsBarSum<<i[:x]
        end
        #ВТОРАЯ ЧАСТЬ
        data = $iiko.IikoPostRequestForSebesMounth("POST.json","CURRENT_MONTH")
        prev = ""

        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                sumCurrent+=iikos['DishDiscountSumInt']
                @@pointsSum2 << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumCurrent }

              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    @@pointsSum2 << { x: prev.next_day.strftime('%d-%m') , y: sumCurrent }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                 sumCurrent+=iikos['DishDiscountSumInt']
                @@pointsSum2 << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumCurrent }
              else
                sumCurrent+=iikos['DishDiscountSumInt']
                @@pointsSum2 << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: sumCurrent }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
              #@@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
        end

        @@pointsSum2.each do |i|
            @@DishDiscountSumIntsSum2<<i[:y]
        end

        @@pointsSum2.each do |i|
            @@labelsBarSum2<<i[:x]
        end

        data = [
            {
              label: 'Прошлый',
              data: @@DishDiscountSumIntsSum,
              backgroundColor: [ 'rgba(128, 166, 255,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * @@labelsBarSum2.length,
              borderWidth: 1,

            },
            {
              label: 'Текущий',
              data: @@DishDiscountSumIntsSum2,
              backgroundColor: [ 'rgba(82, 204, 0,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * @@labelsBarSum2.length,
              borderWidth: 1,

            }
        ]
        send_event('barchartSum', { labels: @@labelsBarSum2, datasets: data })

        #График выручки по дням за месяц
        @@points.shift(@@points.length)
        @@labelsBar.shift(@@labelsBar.length)
        @@DishDiscountSumInts.shift(@@DishDiscountSumInts.length)
        data = $iiko.IikoPostRequest("POST.json")
        prev = ""
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                @@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    @@points << { x: prev.next_day.strftime('%d-%m') , y: 0 }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                @@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
              else
                @@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
              #@@points << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt'] }
        end

        @@points.each do |i|
            @@DishDiscountSumInts<<i[:y]
        end

        @@points.each do |i|
            @@labelsBar<<i[:x]
        end

        data = [
            {
              label: 'Выручка',
              data: @@DishDiscountSumInts,
              backgroundColor: [ 'rgba(128, 128, 128,1)' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * @@labelsBar.length,
              borderWidth: 1,

            }
        ]
        send_event('barchart', { labels: @@labelsBar, datasets: data })

        #График среднего чека по дням

        @@pointsSr.shift(@@pointsSr.length)
        @@labelsBarSr.shift(@@labelsBarSr.length)
        @@DishDiscountSumIntsSr.shift(@@DishDiscountSumIntsSr.length)

        data = $iiko.IikoPostRequest("SrCheck.json")
        prev = ""
        data['data'].each do |iikos|

              if prev == ""
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                @@pointsSr << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt.average'] }
              elsif prev.next_day != Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
                while prev.next_day!=Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d") do
                    @@pointsSr << { x: prev.next_day.strftime('%d-%m') , y: 0 }
                    prev = prev.next_day
                end
                 prev = prev.next_day
                @@pointsSr << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt.average'] }
              else
                @@pointsSr << { x: Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d").strftime('%d-%m') , y: iikos['DishDiscountSumInt.average'] }
                prev = Date::strptime(iikos['OpenDate.Typed'].to_s, "%Y-%m-%d")
              end
        end

        @@pointsSr.each do |i|
            @@DishDiscountSumIntsSr<<i[:y]
        end

        @@pointsSr.each do |i|
            @@labelsBarSr<<i[:x]
        end

        data = [
            {
              label: 'Средний чек',
              data: @@DishDiscountSumIntsSr,
              backgroundColor: [ '#ff9900' ] ,
              borderColor: [ 'rgba(0, 0, 0,1)' ] * @@labelsBarSr.length,
              borderWidth: 1,

            }
        ]
        send_event('barchartSr', { labels: @@labelsBarSr, datasets: data })
    end
end

bar = Bar.new

SCHEDULER.every '15m', :first_in => 0 do |job|
  bar.UseBar()
end
