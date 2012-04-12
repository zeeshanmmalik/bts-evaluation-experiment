require 'csv'
class ExperimentsController < ApplicationController
  before_filter :authenticate_admin!
  # GET /experiments
  # GET /experiments.json
  def index
    @experiments = Experiment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show
    @experiment = Experiment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @experiment }
    end
  end

  # GET /experiments/new
  # GET /experiments/new.json
  def new
    @experiment = Experiment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @experiment }
    end
  end

  # GET /experiments/1/edit
  def edit
    @experiment = Experiment.find(params[:id])
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @experiment = Experiment.new(params[:experiment])

    respond_to do |format|
      if @experiment.save
        format.html { redirect_to @experiment, notice: 'Experiment was successfully created.' }
        format.json { render json: @experiment, status: :created, location: @experiment }
      else
        format.html { render action: "new" }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /experiments/1
  # PUT /experiments/1.json
  def update
    @experiment = Experiment.find(params[:id])

    respond_to do |format|
      if @experiment.update_attributes(params[:experiment])
        format.html { redirect_to @experiment, notice: 'Experiment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.json
  def destroy
    @experiment = Experiment.find(params[:id])
    @experiment.destroy

    respond_to do |format|
      format.html { redirect_to experiments_url }
      format.json { head :no_content }
    end
  end

  def result
    @experiment = Experiment.find(params[:id])
    @total_submissions = @experiment.participants.where('eval_submitted_at IS NOT NULL and eval_submitted_at != ""')
    @lex_submissions = @total_submissions.where(:summary_assigned => 'lexrank')
    @email_submissions = @total_submissions.where(:summary_assigned => 'email')

    @lex = populate_result(@lex_submissions, 'lex')
    @email = populate_result(@email_submissions, 'email')

    respond_to do |format|
      format.html #result.html.haml
      format.json { head :no_content }
    end
  end

  def export_results
    experiment = Experiment.find(params[:id])

    csv_string = CSV.generate do |csv|
      cols = ["experiment","user_id","summary","question","choice"]
      csv << cols
      csv = experiment_csv(experiment, csv)
    end
    filename = "#{experiment.title}-data-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)  
  end

  def export_all_results
    csv_string = CSV.generate do |csv|
      cols = ["experiment","user_id","summary","question","choice"]
      csv << cols
      Experiment.all.each do |experiment|
        csv = experiment_csv(experiment, csv)        
      end
    end
    filename = "all-experiments-data-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)  
  end

  private

  def experiment_csv experiment, csv
    total_submissions = experiment.participants.where('eval_submitted_at IS NOT NULL and eval_submitted_at != ""')
    lex_submissions = total_submissions.where(:summary_assigned => 'lexrank')
    email_submissions = total_submissions.where(:summary_assigned => 'email')
    csv = submission_csv(experiment.title, lex_submissions, 'lex', csv)
    csv = submission_csv(experiment.title, email_submissions, 'email', csv)
    return csv
  end

  def submission_csv exp_title, submissions, str, csv
    submissions.each do |p|
      r = p.response
      rep_part = [exp_title, p.id, p.summary_assigned]
      csv << rep_part + ['1a', r.send("imp_points_incl_#{str}_sum")]
      csv << rep_part + ['1b', r.send("redundancy_#{str}_sum")]
      csv << rep_part + ['1c', r.send("unnecessary_info_#{str}_sum")]
      csv << rep_part + ['1d', r.send("coherence_#{str}_sum")]
      csv << rep_part + ['4a', r.sum_help_bug_similar]
      csv << rep_part + ['4b', r.sum_help_bug_workaround]
      csv << rep_part + ['4c', r.sum_help_bug_status]
      csv << rep_part + ['4d', r.sum_help_bug_life]
      csv << rep_part + ['4e', r.sum_help_proj_cont]
      csv << rep_part + ['4f', r.sum_help_dev]
      csv << rep_part + ['4g', r.sum_help_non_dev]
      csv << rep_part + ['5', r.summary_view_pref]
    end
    return csv
  end

  def populate_result submissions, str
    result = {:imp_points => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :redundancy => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :unnecessary_info => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :coherence => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0}
    }
    submissions.each do |p|
      result[:imp_points]["r#{p.response.send('imp_points_incl_'+str+'_sum')}".to_sym] += 1
      result[:redundancy]["r#{p.response.send('redundancy_'+str+'_sum')}".to_sym] += 1
      result[:unnecessary_info]["r#{p.response.send('unnecessary_info_'+str+'_sum')}".to_sym] += 1
      result[:coherence]["r#{p.response.send('coherence_'+str+'_sum')}".to_sym] += 1
    end
    return result
  end
end
