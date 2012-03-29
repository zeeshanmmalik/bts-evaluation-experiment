class SurveyController < ApplicationController
  before_filter :authenticate_participant
  rescue_from Exceptions::ParticipantNotAuthenticated, :with => :participant_not_authenticated

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
