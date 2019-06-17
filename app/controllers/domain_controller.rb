class DomainController < ApplicationController
	before_action :authenticate_user! 


	def domain_list
		#  	@result = Whois.whois("izmirbeyazesyaklimaservisi.com")
		#  	@parser = @result.parser
		#  	@sure = @parser.expires_on

		@domains = current_user.domains.all
		respond_to do |format|
			format.html
			format.json {render json: @result }
		end
	end

	def add_domains
		@domain = Domain.new
		respond_to do |format|
			format.html
			format.json {render json: @result }
		end
	end

	def add_domains_save

		@save = current_user.domains.new(domain_save_params)
		if @save.validate

			domain_info = domain_information(domain_save_params["domain_name"])
			# Eğer domain kullanılabilir durumda ise hiç kaydetme
			if domain_info.available?
				redirect_to domain_list_path, notice: "You can already buy the domain name"
				return false
			end

			@save.color = "%06x" % (rand * 0xffffff)
			@save.expire_time = domain_info.expires_on
			# Domaini kaydediyoruz
			if @save.save
				# Domaini kaydettikten sonra job'a atıyoruz
				job = DomainCheckWorker.perform_at(1.minutes.from_now, @save.id)
				# Job atadıktan sonra job_id sini domain satırına kaydediyoruz
				@save.job_id = job
				@save.save
				
				redirect_to domain_list_path, notice: "Domain successfully created"
			else
				delete_job(job)
				redirect_to domain_list_path, alert: @save.errors.full_messages.first
			end
		else
			redirect_to domain_list_path, alert: @save.errors.full_messages.first
		end
	end

	def del_domain
		domain = current_user.domains.find(params[:id])
		if domain.destroy
			delete_job(domain.job_id)
			redirect_to domain_list_path, notice: "Domain successfully deleted"
		else
			redirect_to domain_list_path, alert: domain.errors.full_messages.first
		end
	end

	private
	def all_info
		@domains = Domain.all
	end

	def domain_save_params
		params.require("domain").permit("domain_name", "description")
	end

	def domain_information(domain)
	  	result = Whois.whois(domain)
  		return result.parser
  		# @sure = @parser.expires_on
	end

	def delete_job(job_id)
		Sidekiq::ScheduledSet.new.find_job(job_id).delete
	end
end
