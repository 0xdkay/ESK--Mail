# encoding: cp949
$:.unshift('.')
require "ESK3-KAISTmail"
require "yaml"
require "csv"

a = open(Dir.home+"/mine") {|v| YAML.load(v.read)}
b = KaistMail.new
b.login(a[:id],a[:pw])

senderhp = a[:sender]

receiverhp = []

print "Enter the context: "
s_context = gets.chomp.encode("UTF-8")
while (s_context.size > 80)
	puts "The context should be less than 80 words."
	print "Enter the context: "
	s_context = gets.chomp.encode("UTF-8")
end

i=1
loop do
	print "Enter receiver \##{i}'s phonenumber: "
	tmp = gets.chomp
	
	break if tmp.empty?
	i += 1

	rclist = CSV.readlines(File.join(Dir.home,"list.csv")).map{|v| v.map {|j| j && j.force_encoding("EUC-KR")}}
	c = /^#{tmp}/
	tt = rclist.select {|v| v[0] =~ c}.map {|v| v[1]}.compact
	
	if tt.empty?	
		redo if not tmp =~ /\A\d+\z/
		receiverhp.push(tmp)
		puts "To #{tmp}"
	else
		receiverhp.push(*tt)
		puts "To #{tt.join(' ')}"
	end
end
if b.sendsms(senderhp,receiverhp,s_context)
	puts "Sending Success!!"
else
	puts "You Fail!"
end
