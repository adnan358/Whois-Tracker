namespace :vt do
	task reset: :environment do
		Rake::Task['db:drop'].execute
		Rake::Task['db:create'].execute
		Rake::Task['db:migrate'].execute
	end
end
