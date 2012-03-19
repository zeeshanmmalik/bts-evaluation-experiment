class Experiment < ActiveRecord::Base
  has_many :participants
  has_many :bug_reports
end
