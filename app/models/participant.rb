class Participant < ActiveRecord::Base
  belongs_to :experiment
  has_many :comments, :dependent => :destroy
  belongs_to :bug_report
  has_one :response, :dependent => :destroy
  has_many :participants_sentences, :dependent => :destroy
end
