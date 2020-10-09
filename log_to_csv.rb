#!/usr/bin/env ruby

require 'pry'
require 'pp'

csv_fn = ARGV[0]
log_fn = ARGV[1]
out_fn = ARGV[2]

p ARGV

#cmd = "grep Cannot #{csv_fn}\n"
#cmd = "grep Cannot ../slaveryimages/logs/log.txt\n"

log_lines = File.readlines(log_fn)

bad_files = []

log_lines.each do |line|
	#  "Cannot sideload file \"\/var\/www\/html\/sideload_images\/pdfs\/1817 Esperan\u00e7a Fortuna V7677\/1817-04-24 Esperan\u00e7a V7677 Register1 SLR10583-10990.pdf\". File does not exist or does not have sufficient permissions"
	md = line.match? /Cannot sideload file.*sideload_images\/pdfs\/(.*)"/
	md = line.match /Cannot sideload file.*sideload_images\\\/pdfs\\\/(.*)\\"/
	if md
		filename = md[1]
		p filename
		bad_files << filename
	end
end

csv_lines = File.readlines(csv_fn)
csv_header = csv_lines[0]
csv_data = csv_lines[1..]

# look for error files within each line
failed_lines = []

bad_files.each do |filename|
	csv_data.each do |csv_line|
		if csv_line.match? /#{filename}/
			failed_lines << csv_line
		end
	end
end
#binding.pry

File.write(out_fn, ([csv_header] + failed_lines).join(""))

#p cmd

#p `cmd`

p "done"