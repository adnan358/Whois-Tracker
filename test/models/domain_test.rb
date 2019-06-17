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

require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
