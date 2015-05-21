require 'time'

input_log = File.open('access.log')
output_log = []

sharding_nodes = 1
for i in 0...sharding_nodes

	output_log <<  File.new("access_formatted_#{i}.log", "w+")

end


simu_load = 1
temp_log = File.new("temp.log", "w+")
#set sync mode to true, it will enable immediately flushed to the underlying operating system
temp_log.sync = true
#or flush the temp log after the file write operation complete "temp_log.flush"

input_log.each_line do |line|

	simu_load.times do 

		acc_arr = line.split(' ')

		r_ts_arr = acc_arr[2].delete("[").split(':')
		r_ts_str = r_ts_arr.drop(1).join(':')
		#Time.parse() gives the seconds since the Epoch
		#need to convert to millis
		r_ts = Time.parse(r_ts_str).to_i * 1000

		r_method = acc_arr[4].delete("\"")
		r_url = acc_arr[5]

		temp_log.puts("#{r_ts},#{r_method},#{r_url}")
	end

end


fd = File.open("temp.log")

fd.each do |line|

	file_index = fd.lineno%sharding_nodes

	output_log[file_index].puts(line)

end

for i in 0...sharding_nodes
	output_log[i].close
end

File.delete("temp.log")