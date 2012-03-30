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
  class EmailDoesNotExist < StandardError
    def initialize(msg)
      @message = msg
    end
    def message
      @message
    end
  end
end
