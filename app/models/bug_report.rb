class BugReport < ActiveRecord::Base
  belongs_to :experiment
  has_many :participants
  has_many :comments, :dependent => :destroy
  has_many :responses, :dependent => :destroy
end
