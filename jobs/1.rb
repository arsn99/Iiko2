 load 'Iiko.rb'
 $iiko = Iiko::IikoRequests.new
 #$iiko.TelegramMessage()
 begin
	$iiko.GetToken()
 rescue
	puts "Токен не получен."
	$iiko.Finalize()
 end

 SCHEDULER.every '300s', :first_in => '20s' do |job|
	#$iiko.CheckToken()
	$iiko.Finalize()
end
