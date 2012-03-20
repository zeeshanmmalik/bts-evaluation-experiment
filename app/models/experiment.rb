class Experiment < ActiveRecord::Base
  has_many :participants, :dependent => :destroy
  has_many :bug_reports, :dependent => :destroy
end
