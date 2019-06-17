class SendMailMailer < ApplicationMailer
	def first_mail(domain)
		@domain = domain
		user = User.find(@domain.user_id)
		mail(to: user.email, subject: 'Domain için son gün!!')
	end

	def domain_was_buy(domain)
		@domain = domain
		user = User.find(@domain.user_id)
		mail(to: user.email, subject: 'Domain satın alındı :/')
	end

	def can_buy_domain(domain)
		@domain = domain
		user = User.find(@domain.user_id)
		mail(to: user.email, subject: 'Domain satın alındı :/')
	end
end
