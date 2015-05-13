require 'time'

input_log = File.open('access.log')
output_log = File.new('access_formatted.log', 'w+')

simu_load = 1

input_log.each_line do |line|
	simu_load.times do 
		acc_arr = line.split(' ')

		r_ts_arr = acc_arr[2].delete("[").split(':')
		r_ts_str = r_ts_arr.drop(1).join(':')
		#Time.parse() gives the seconds since the Epoch
		#need to convert to millis
		p r_ts = Time.parse(r_ts_str).to_i * 1000

		r_method = acc_arr[4].delete("\"")
		r_url = acc_arr[5]

		output_log.puts("#{r_ts},#{r_method},#{r_url}")
	end

end

output_log.close