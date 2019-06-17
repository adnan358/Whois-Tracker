# == Schema Information
#
# Table name: domains
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  domain_name :string
#  description :string
#  expire_time :datetime         not null
#  color       :string
#  job_id      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Domain < ApplicationRecord
	has_one :user

	validates_format_of :domain_name, :with => /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, multiline: true

	validates :domain_name, presence: true, uniqueness: { scope: [:user_id, :domain_name] }
end
