class Sentence < ActiveRecord::Base
  belongs_to :comment
  has_many :participants_sentences, :dependent => :destroy
end
