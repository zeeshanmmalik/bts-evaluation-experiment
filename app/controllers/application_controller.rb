require 'exceptions'
class ApplicationController < ActionController::Base
  protect_from_forgery
  ### Followings don't work in Rails 3 because now routing is done in middleware (ActionDispatch) and hence ApplicationController never gets invoked
  #rescue_from ActionController::RoutingError, :with => :route_not_found
  #rescue_from ActionController::MethodNotAllowed, :with => :invalid_method

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ActionController::UnknownAction, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end


  private

  def authenticate_participant
    # verify participant with access token
    # if not verified redirect to appropriate error page
    # set @participant if verified
    @participant = Participant.where(:access_token => params[:access_token]).first
    raise Exceptions::ParticipantNotAuthenticated unless @participant
  end

  def participant_not_authenticated
    #message = "Don't you feel lucky by not been selected by our pseudo random algos!"
    #render :text => message, :status => :not_found

    respond_to do |format|
      format.html { render template: 'errors/error_401', layout: 'layouts/application', status: 401 }
      format.all { render nothing: true, status: 401 }
    end
  end

  def render_404(exception)
    @not_found_path = exception.message
    respond_to do |format|
      format.html { render template: 'errors/error_404', layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def render_500(exception)
    @error = exception
    respond_to do |format|
      format.html { render template: 'errors/error_500', layout: 'layouts/application', status: 500 }
      format.all { render nothing: true, status: 500}
    end
  end

  def validate_experiment
    raise ActiveRecord::RecordNotFound unless @participant
    exp = @participant.experiment
    raise ActiveRecord::RecordNotFound unless exp
    start_at = exp.start_at
    raise Exceptions::ExperimentNotStarted.new(exp) if start_at and start_at > Time.now
    end_at = exp.end_at
    raise Exceptions::ExperimentEnded.new(exp) if end_at and end_at < Time.now
  end

  def experiment_not_started(exception)
    @experiment = exception.experiment
    respond_to do |format|
      format.html { render template: 'errors/experiment_not_started', layout: 'layouts/application', status: 401 }
      format.all { render nothing: true, status: 401 }
    end
  end

  def experiment_ended(exception)
    @experiment = exception.experiment
    respond_to do |format|
      format.html { render template: 'errors/experiment_ended', layout: 'layouts/application', status: 401 }
      format.all { render nothing: true, status: 401 }
    end
  end

  
  # def route_not_found
  #   message = "What the fuck are you looking for?"
  #   render :text => message, :status => :not_found
  # end

  # def invalid_method
  #   message = "Now, did your mom tell you to #{request.request_method.to_s.upcase} that ?"
  #   render :text => message, :status => :method_not_allowed
  # end

end
