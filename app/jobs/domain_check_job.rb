class DomainCheckJob < ApplicationJob
	queue_as :default

	def perform(domain)
		# Domaini tekrardan kontrol et, eğer domain satın alınmamışsa yani expire_time suanki tarihten büyük değilse kullanıcıya mail gönder
		if domain.expire_time <= DateTime.now

			# domainin düştüğü gün ile aynı ise kullanıcıya mail gönder
			if Date.new(domain.expire_time.year, domain.expire_time.month, domain.expire_time.day).today?
				# Satın almak istediğin domainin bugün son günü, hatta suan son dakikaları istersen bir kontrol et
				SendMailMailer.first_mail(domain)
			end

			# ertesi gün domain uzatılmışsa kullanıcıya mail at, ve job atama
			if domain.expire_time > DateTime.now
				# Domain satın alındı, süresi uzatıldı haberin olsun
				SendMailMailer.domain_was_buy(domain)
			elsif domain_information(domain.domain_name).available?
				# Domaini satın alabilirsin
				SendMailMailer.can_buy_domain(domain)
			else
				# ertesi gün domain uzatılmamışsa tekrardan job'u +1 gün uzat
				DomainCheckJob.set(wait_until: 1.days.after).perform_later(domain)
			end
		else
			# İstediğin domain günler öncesinde uzatılmış
			SendMailMailer.domain_was_buy(domain)
		end
	end

	def domain_information(domain_name)
		result = Whois.whois(domain_name)
  		return result.parser
	end
end
