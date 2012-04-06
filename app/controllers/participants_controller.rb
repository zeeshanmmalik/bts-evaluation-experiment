class ParticipantsController < ApplicationController
  before_filter :authenticate_admin!

  def send_invitation_email
    participant = Participant.find(params[:id])
    name = "#{participant.id}:#{participant.name || participant.username || participant.email}"
    if not participant.email
      message = "Email address for #{name} does not exist. Invitation email could not be sent."
    elsif participant.is_email_sent?
      message = "Invitation email to #{name} has already been sent."
    else
      begin
        ParticipantMailer.invitation_email(participant).deliver
        participant.is_email_sent = true;
        participant.save!
        message = "Invitation email to #{name} was successfully sent."
      rescue Exception => e
        AdminMailer.exception_notification_email(e).deliver
        message = "Invitation email to #{name} could not be sent. Error: #{e.message}"
      end
    end
    render :text => message
  end
end
