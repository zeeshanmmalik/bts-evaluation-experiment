class Sentence < ActiveRecord::Base
  belongs_to :comment
  has_many :sentence_evaluations, :dependent => :destroy
  has_many :participants, :through => :sentence_evaluations
end
