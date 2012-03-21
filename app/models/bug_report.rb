class BugReport < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :participant
  has_many :comments, :dependent => :destroy
end
