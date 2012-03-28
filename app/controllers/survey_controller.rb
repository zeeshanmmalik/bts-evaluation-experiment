class SurveyController < ApplicationController
  before_filter :authenticate_participant
  rescue_from Exceptions::ParticipantNotAuthenticated, :with => :participant_not_authenticated

  def access
    @participant.response = @participant.response || Response.new
    @bug_report = @participant.bug_report    
  end

  def submit
    @participant.response.update_attributes(params[:response])
    redirect_to access_survey_path

    params[:sentences].each do |sen_id, imp|
      ParticipantsSentences.create(:participant_id => @participant.id, :sentence_id => sen_id, :importance => imp)
    end
  end
end
