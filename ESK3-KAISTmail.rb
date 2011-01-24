# -*- encoding: cp949 -*- 
require 'rubygems'
require 'mechanize'


class KaistMail
	def login(user_id,user_passwd)
		a = Mechanize.new
		r = a.get('http://mail.kaist.ac.kr').frame('main').click
		@r2 = r.form('login') do |f|
			f.USERS_ID = user_id
			f.USERS_PASSWD = user_passwd
			f.action = "https://mail.kaist.ac.kr/nara/servlet/user.UserServ"
			f.cmd = 'login'
		end.submit
		if self.login?
			return @r2
		else
			return false
		end
	end

	def login?
		return @r2 !~ /logout/
	end

	def sendsms(sender_hp,receiver_hp,message)
		t2 = @r2.link(:text => "SMS").click
		t3 = t2.form('f') do |v|
			if v.quota.to_i <= 0
					puts "There are no free sms left."
					return false
			end
			v.sendHp = sender_hp
			v.receiveHp = receiver_hp
			v.toMessage = message
		end.submit
		t4 = t3.search('//span[@class="t_menu_vioB"]/node()').map(&:to_s).map(&:to_i)
		return t4[0] == t4[1] && t4[0] != 0 && t4[3] == 0 && t4[4] == 0
	end

	def self.sendsms(user_id,user_passwd,sender_hp,receiver_hp,message)
		a = self.new
		a.login(user_id,user_passwd)
		if a.login?
			return a.sendsms(sender_hp,receiver_hp,message)
		else
			return false
		end
	end
end


#----------------------main--------------------------
if __FILE__ == $0

	print "Enter your e-mail id: "
	userid = gets.chomp

	print "Enter your e-mail password: "
	userpasswd = gets.chomp

	a = KaistMail.new
	a.login(userid,userpasswd)

	print "Enter the context: "
	s_context = gets.chomp.encode("UTF-8")
	while (s_context.size > 80)
		puts "The context should be less than 80 words."
		print "Enter the context: "
		s_context = gets.chomp.encode("UTF-8")
	end

	print "Enter sender phonenumber: "
	senderhp = gets.chomp
	while not senderhp =~ /\A\d+\z/
		print "Please input proper number: "
		senderhp = gets.chomp
	end

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

	a.sendsms(senderhp,receiverhp,message)

	end	
end


