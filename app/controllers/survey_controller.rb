class SurveyController < ApplicationController
  before_filter :authenticate_participant
  before_filter :validate_experiment
  rescue_from Exceptions::ParticipantNotAuthenticated, :with => :participant_not_authenticated
  rescue_from Exceptions::ExperimentNotStarted, :with => :experiment_not_started
  rescue_from Exceptions::ExperimentEnded, :with => :experiment_ended

  def access
    @participant.response = @participant.response || Response.new
    @bug_report = @participant.bug_report    
  end

  def submit
    @participant.response.update_attributes(params[:response])

    # amazing... code continues after redirecting
    #redirect_to access_survey_path
    redirect_to thanks_survey_path

    params[:sentences].each do |sen_imp|
      sen_imp.each do |sen_id, imp|
        pse = @participant.sentence_evaluations.find_or_initialize_by_sentence_id(:sentence_id => sen_id)
        pse.importance = imp
        pse.save!
      end
    end
  end

  def thanks    
  end
end
