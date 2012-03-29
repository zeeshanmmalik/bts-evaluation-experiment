# lib/exceptions.rb
module Exceptions
  class ParticipantNotAuthenticated < StandardError; end
  class ExperimentNotStarted < StandardError
    def initialize(exp)
      @experiment = exp
    end
    def experiment
      @experiment
    end
  end
  class ExperimentEnded < StandardError
    def initialize(exp)
      @experiment = exp
    end
    def experiment
      @experiment
    end
  end
end
