class BugReportsController < ApplicationController
  before_filter :authenticate_admin!
  # GET /bug_reports
  # GET /bug_reports.json
  def index
    if params[:exp_id] and Experiment.exists?(params[:exp_id])
      @bug_reports = Experiment.find(params[:exp_id]).bug_reports
    else
      @bug_reports = BugReport.all
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bug_reports }
    end
  end

  # GET /bug_reports/1
  # GET /bug_reports/1.json
  def show
    @bug_report = BugReport.find(params[:id])

    # just for the page to work... very bad practice... you should be flogged for doing this
    @participant = Participant.new
    @participant.response = Response.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bug_report }
    end
  end

  def compare_summary
    @bug_report = BugReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bug_report }
    end    
  end

  # GET /bug_reports/new
  # GET /bug_reports/new.json
  def new
    @bug_report = BugReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bug_report }
    end
  end

  # GET /bug_reports/1/edit
  def edit
    @bug_report = BugReport.find(params[:id])
  end

  # POST /bug_reports
  # POST /bug_reports.json
  def create
    @bug_report = BugReport.new(params[:bug_report])

    respond_to do |format|
      if @bug_report.save
        format.html { redirect_to @bug_report, notice: 'Bug report was successfully created.' }
        format.json { render json: @bug_report, status: :created, location: @bug_report }
      else
        format.html { render action: "new" }
        format.json { render json: @bug_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bug_reports/1
  # PUT /bug_reports/1.json
  def update
    @bug_report = BugReport.find(params[:id])

    respond_to do |format|
      if @bug_report.update_attributes(params[:bug_report])
        format.html { redirect_to @bug_report, notice: 'Bug report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bug_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bug_reports/1
  # DELETE /bug_reports/1.json
  def destroy
    @bug_report = BugReport.find(params[:id])
    @bug_report.destroy

    respond_to do |format|
      format.html { redirect_to bug_reports_url }
      format.json { head :no_content }
    end
  end
end
