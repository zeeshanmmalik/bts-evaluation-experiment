class ParticipantsSentences < ActiveRecord::Base
  belongs_to :participant
  belongs_to :sentence
end
