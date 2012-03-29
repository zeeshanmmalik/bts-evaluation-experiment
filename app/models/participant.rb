class Participant < ActiveRecord::Base
  belongs_to :experiment
  has_many :comments, :dependent => :destroy
  belongs_to :bug_report
  has_one :response, :dependent => :destroy
  has_many :sentence_evaluations, :dependent => :destroy
  has_many :sentences, :through => :sentence_evaluations
end
