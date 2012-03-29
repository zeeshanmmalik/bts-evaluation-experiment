class ParticipantMailer < ActionMailer::Base
  #set in environment cnofiguration files
  #default from: "bugsummary@gsd.uwaterloo.ca"

  def invitation_email(participant)
    @participant = participant
    customized_email('invitation')
    mail(:to => @participant.email, 
         :subject => @subject) do |format|
      format.text { render :text => @body }
    end
  end

  private
  
  def customized_email(email_type)
    experiment = @participant.experiment
    bug_report = @participant.bug_report
    email = experiment.email(email_type)
    @subject = email.subject
    puts 'subject: ' + @subject
    @body = email.body
    puts 'body: ' + @body
    @body.gsub!('[user_name]', @participant.name || '')
    @body.gsub!('[experiment_title]', experiment.title || '')
    @body.gsub!('[experiment_start_date]', experiment.start_at.nil? ? '' : experiment.start_at.strftime("%m/%d/%Y"))
    @body.gsub!('[experiment_start_time]', experiment.start_at.nil? ? '' : experiment.start_at.strftime("%I:%M %p"))
    @body.gsub!('[experiment_end_date]', experiment.end_at.nil? ? '' : experiment.end_at.strftime("%m/%d/%Y"))
    @body.gsub!('[experiment_end_time]', experiment.end_at.nil? ? '' : experiment.end_at.strftime("%m/%d/%Y"))
    @body.gsub!('[bug_report_id]', bug_report.bug_identifier || '')
    @body.gsub!('[bug_report_title]', bug_report.title || '')
    @body.gsub!('[summary_link]', access_survey_url(@participant.access_token))     
  end
end
