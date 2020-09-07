# coding: utf-8
require 'tiny_tds'
# TODO need to refactoring for all SQL requests where used DATEPART, need to change it to DAY,MONTH,YEAR
SCHEDULER.every '5s' do
  client = TinyTds::Client.new(:username=> 'sa', :password => 'Sma215999', :host => '192.168.66.104')
  # populate month,count incoming requests
  result_months = client.execute('select YEAR(servicedesk.dbo.from_unixtime(wo.[CREATEDTIME]/1000)) y,MONTH(servicedesk.dbo.from_unixtime(wo.[CREATEDTIME]/1000)) m, COUNT(*) c from servicedesk.dbo.WorkOrder wo
                                  where (servicedesk.dbo.from_unixtime(wo.[CREATEDTIME]/1000)) between CONVERT(datetime,CAST(YEAR(DATEADD(MONTH,-12,GETDATE())) as varchar(4))+\'-\'+CAST(MONTH(DATEADD(MONTH,-12,GETDATE())) as varchar)+\'- 01 00:00:00\', 120) and GETDATE()
                                  group by YEAR(servicedesk.dbo.from_unixtime(wo.[CREATEDTIME]/1000)), MONTH(servicedesk.dbo.from_unixtime(wo.[CREATEDTIME]/1000))
                                  order by y,m ')
  points = result_months.map do |row|
    row = {
               :x => Date.new(row['y'],row['m'],1).to_time.to_i,
               :y => row['c']
          }
  end
  # populate month,count completed requests
  result_c_month = client.execute( 'select YEAR(servicedesk.dbo.from_unixtime(wo.[COMPLETEDTIME]/1000)) y, MONTH(servicedesk.dbo.from_unixtime(wo.[COMPLETEDTIME]/1000)) mc, COUNT(*) c from servicedesk.dbo.WorkOrder wo
                                    where (servicedesk.dbo.from_unixtime(wo.[COMPLETEDTIME]/1000)) between CONVERT(datetime,CAST(YEAR(DATEADD(MONTH,-12,GETDATE())) as varchar(4))+\'-\'+CAST(MONTH(DATEADD(MONTH,-12,GETDATE())) as varchar)+\'- 01 00:00:00\', 120) and GETDATE()
                                    group by YEAR(servicedesk.dbo.from_unixtime(wo.[COMPLETEDTIME]/1000)),MONTH(servicedesk.dbo.from_unixtime(wo.[COMPLETEDTIME]/1000))
                                    order by y,mc' )
  c_points = result_c_month.map do |row|
  row = {
      :x => Date.new(row['y'],row['mc'],1).to_time.to_i,
      :y => row['c']
  }
  end

series = [
    {
        name: 'Пришло',
        data: points
      },
      {
          name: 'Закрыто',
          data: c_points

      }
  ]

  #this month
  requests_month= client.execute('select COUNT(*)as m from servicedesk.dbo.WorkOrder wo where DATEPART(month,CONVERT(date,servicedesk.dbo.from_unixtime(wo.[CREATEDTIME]/1000))) = DATEPART(month,CONVERT(date,GETDATE())) and DATEPART(YEAR,CONVERT(date,servicedesk.dbo.from_unixtime(wo.[CREATEDTIME]/1000))) = DATEPART(YEAR,CONVERT(date,GETDATE()))')
  current_requests_month = requests_month.collect {|m| m['m']}
  #competed this month
  result_cr_this_month = client.execute('select COUNT(*)as mc from servicedesk.dbo.WorkOrder wo where DATEPART(month,CONVERT(date,servicedesk.dbo.from_unixtime(wo.[COMPLETEDTIME]/1000))) = DATEPART(month,CONVERT(date,GETDATE())) and DATEPART(YEAR,CONVERT(date,servicedesk.dbo.from_unixtime(wo.[COMPLETEDTIME]/1000))) = DATEPART(YEAR,CONVERT(date,GETDATE()))')
  current_cr_month = result_cr_this_month.collect { |mc| mc['mc'] }

  client.close

  # send_event('month_requests', points: points)
  # send_event('month_c_requests', points: c_points)
  send_event('month_co_requests', series: series, displayedValue: current_requests_month.join+'/'+current_cr_month.join )
end