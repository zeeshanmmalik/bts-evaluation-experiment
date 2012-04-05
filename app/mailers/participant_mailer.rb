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
    @body = email.body

    APP_CONFIG[:email_markers_mapping]['participant'].each do |marker, mapping|
      val = @participant.send(mapping)
      if mapping == 'access_token'
        @body.gsub!('['+marker+']', val.blank? ? '' : access_survey_url(val))
        @subject.gsub!('['+marker+']', val.blank? ? '' : access_survey_url(val))        
      else
        @body.gsub!('['+marker+']', val.blank? ? '' : val)
        @subject.gsub!('['+marker+']', val.blank? ? '' : val)
      end
    end

    APP_CONFIG[:email_markers_mapping]['experiment'].each do |marker, mapping|
      val = experiment.send(mapping)
      @body.gsub!('['+marker+']', val.blank? ? '' : val.to_s)
      @subject.gsub!('['+marker+']', val.blank? ? '' : val.to_s)
    end

    APP_CONFIG[:email_markers_mapping]['bug_report'].each do |marker, mapping|
      val = bug_report.send(mapping)
      @body.gsub!('['+marker+']', val.blank? ? '' : val)
      @subject.gsub!('['+marker+']', val.blank? ? '' : val)
    end

    #puts "++++++++++\n#{@body}\n++++++++++++++"
    # @body.gsub!('[user_name]', @participant.name || '')
    # @body.gsub!('[experiment_title]', experiment.title || '')
    # @body.gsub!('[experiment_start_date]', experiment.start_at.nil? ? '' : experiment.start_at.strftime("%m/%d/%Y"))
    # @body.gsub!('[experiment_start_time]', experiment.start_at.nil? ? '' : experiment.start_at.strftime("%I:%M %p"))
    # @body.gsub!('[experiment_end_date]', experiment.end_at.nil? ? '' : experiment.end_at.strftime("%m/%d/%Y"))
    # @body.gsub!('[experiment_end_time]', experiment.end_at.nil? ? '' : experiment.end_at.strftime("%m/%d/%Y"))
    # @body.gsub!('[bug_report_id]', bug_report.bug_identifier || '')
    # @body.gsub!('[bug_report_title]', bug_report.title || '')
    # @body.gsub!('[summary_link]', access_survey_url(@participant.access_token))

    puts 'subject: ' + @subject
  end
end
