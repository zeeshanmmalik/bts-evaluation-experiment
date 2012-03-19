class Participant < ActiveRecord::Base
  belongs_to :experiment
  has_many :comments
  has_one :bug_report
end
