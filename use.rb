# encoding: cp949
$:.unshift('.')
require "ESK3-KAISTmail"
require "yaml"
require "csv"

a = open(Dir.home+"/mine") {|v| YAML.load(v)}
=begin

b = KaistMail.new
b.login(a['id'],a['pw'])
puts b.login?
=end

senderhp = a['sender']

receiverhp = []
rclist = CSV.readlines(File.join(Dir.home,"list.csv")).map{|v| v.map {|j| j && j.force_encoding("EUC-KR")}}

loop do
	print "Enter your receiver: "
	c = gets.chomp
	break if c.empty?
	c = /^#{c}/
	puts receiverhp.push(*rclist.select {|v| v[0] =~ c}.map {|v| v[1]}.compact)
end

print "Enter the context: "
s_context = gets.chomp.encode("UTF-8")
while (s_context.size > 80)
	puts "The context should be less than 80 words."
	print "Enter the context: "
	s_context = gets.chomp.encode("UTF-8")
end

=begin
receiverhp = []
i=1
loop do
	print "Enter receiver \##{i}'s phonenumber: "
	tmp = gets.chomp
	redo if not tmp =~ /\A\d+\z/
	i+=1

	receiverhp.push(tmp)
	print "Do you want add more receiver?(y/n)"
	checker = gets.chomp
	while (checker != "y" && checker != "n")
		print "Select \"y\" or \"n\": "
		checker = gets.chomp
	end

	break if not checker == "y"
end
=end
b.sendsms(senderhp,receiverhp,message)
