data = $iiko.IikoPostRequest()

points= []
labelsNew = []
DishDiscountSumInt1 = []
labels = ['January', 'February', 'March', 'April', 'May', 'June', 'July','Aug']

data['data'].each do |iikos|
	  points << { x:iikos['Mounth'][0..1].to_i , y: iikos['DishDiscountSumInt.average'] }
	  
end

points.each do |i|
	DishDiscountSumInt1<<i[:y]
end

points.each do |i|
	labelsNew<<labels[i[:x]-1]
end

SCHEDULER.every '10s', :first_in => 0 do |job|

  data = [
    {
      label: '2018',
      data: DishDiscountSumInt1,
      backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * labelsNew.length,
      borderColor: [ 'rgba(255, 99, 132, 1)' ] * labelsNew.length,
      borderWidth: 1,
    }, {
      label: '2019',
      data: Array.new(labelsNew.length) { rand(40..80) },
      backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * labelsNew.length,
      borderColor: [ 'rgba(255, 206, 86, 1)' ] * labelsNew.length,
      borderWidth: 1,
    }
  ]

  send_event('linechart', { labels: labelsNew, datasets: data })
end