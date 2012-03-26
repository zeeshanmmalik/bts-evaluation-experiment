class Response < ActiveRecord::Base
  belongs_to :participant
  belongs_to :bug_report
end
