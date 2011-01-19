# -*- encoding: cp949 -*- 
require 'rubygems'
require 'mechanize'


class KaistMail
	def self.login(user_id,user_passwd)
	@a = Mechanize.new
	@r = @a.get('http://mail.kaist.ac.kr').frame('main').click
	@r2 = @r.form('login') do |f|
		f.USERS_ID = user_id
		f.USERS_PASSWD = user_passwd
		f.action = "https://mail.kaist.ac.kr/nara/servlet/user.UserServ"
		f.cmd = 'login'
	end.submit
	puts "login success"
	return @r2
	end

	def self.login?
	if(@r2.body.scan('logout').size)
		puts "Login Success."
		return true
	else
		puts "Login failed."
		return false
	end
	end
	
	def self.sendmsg(user_id,user_passwd,sender_hp,receiver_hp,message)
	@t = self.login(user_id,user_passwd)
	@t2 = @t.link(:text => "SMS").click
	@t3 = @t2.form('f') do |v|
		v.sendHp = sender_hp
		v.receiveHp = receiver_hp
		v.toMessage = message
	end.submit
	if(@t3.body.scan("img sms result.gif").size)
		puts "Success!! Message was sent."
		return true
	else
		puts "Fail.. Nah......."
		return false
	end	
	end
end


#----------------------main--------------------------

print "Enter your e-mail id: "
userid = gets.chomp

print "Enter your e-mail password: "
userpasswd = gets.chomp

print "Enter the context: "
s_context = gets.chomp.encode("UTF-8")
while(s_context.size > 80)
	puts "The context should be less than 80 words."
	print "Enter the context: "
	s_context = gets.chomp.encode("UTF-8")
end


print "Enter sender phonenumber: "
senderhp = gets.chomp
while(senderhp.scan(/\d/).size != senderhp.size)
      print "Please input proper number: "
	senderhp = gets.chomp
end

receiverhp = []
i=1
while(1)
	tmp = "aa"
	print "Enter receiver \##{i}'s phonenumber: "
	tmp = gets.chomp
	while(tmp.scan(/\d/).size != tmp.size)
		   print "Please input proper number: "
		   tmp = gets.chomp
	end
	receiverhp.push(tmp)
	print "Do you want add more receiver?(y/n)"
	checker = gets.chomp
	while (checker != "y" && checker != "n")
		  print "Select \"y\" or \"n\"."
		  checker = gets.chomp
	end
	if checker == "y"
		i+=1
	else
		break
	end
end

KaistMail.sendmsg(userid,userpasswd,senderhp,receiverhp,s_context)
