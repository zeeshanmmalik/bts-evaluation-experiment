class Participant < ActiveRecord::Base
  belongs_to :experiment
  has_many :comments, :dependent => :destroy
  has_one :bug_report
end
