require "Action_View"
include ActionView::Helpers::NumberHelper

data = $iiko.IikoPostRequest()
points= []
labelsBar = []
DishDiscountSumInts = []
labels = ['January', 'February', 'March', 'April', 'May', 'June', 'July','Aug']

data['data'].each do |iikos|
	  points << { x:iikos['Mounth'][0..1].to_i , y: iikos['DishDiscountSumInt.average'] }
	  
end

points.each do |i|
	DishDiscountSumInts<<i[:y]
end

points.each do |i|
	labelsBar<<labels[i[:x]-1]
end

SCHEDULER.every '10s', :first_in => 0 do |job|

  data = [
    {
      label: '2018',
      data: DishDiscountSumInts,
      backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * labelsBar.length,
      borderColor: [ 'rgba(255, 99, 132, 1)' ] * labelsBar.length,
      borderWidth: 1,
    }, {
      label: '2019',
      data: DishDiscountSumInts,
      backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * labelsBar.length,
      borderColor: [ 'rgba(255, 206, 86, 1)' ] * labelsBar.length,
      borderWidth: 1,
    }
  ]
  send_event('barchart', { labels: labelsBar, datasets: data })
end