class BugReport < ActiveRecord::Base
  belongs_to :experiment
  belongs_to :participant #is assigned to a participant for evaluation
  has_many :comments, :dependent => :destroy
end
