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
    @total_bug_reports = @experiment.bug_reports.map{|b| b.used? ? 1:0}.reduce(:+)
    @total_invitations = @experiment.participants.where(:is_email_sent => true).count
    @lex_invitations = @experiment.participants.where(:is_email_sent => true, :summary_assigned => 'lexrank').count
    @email_invitations = @experiment.participants.where(:is_email_sent => true, :summary_assigned => 'email').count
    @total_accessed = @experiment.participants.where("eval_started_at IS NOT NULL and eval_started_at != ''").count
    @lex_accessed = @experiment.participants.where("summary_assigned = 'lexrank' and eval_started_at IS NOT NULL and eval_started_at != ''").count
    @email_accessed = @experiment.participants.where("summary_assigned = 'email' and eval_started_at IS NOT NULL and eval_started_at != ''").count
    @all_submissions = @experiment.participants.where("eval_submitted_at IS NOT NULL and eval_submitted_at != ''")
    @lex_submissions = @all_submissions.where(:summary_assigned => 'lexrank')
    @email_submissions = @all_submissions.where(:summary_assigned => 'email')

    @q1_lex = populate_result(@lex_submissions, 'lex')
    @q1_email = populate_result(@email_submissions, 'email')
    @q4 = q4_result(@all_submissions)

    respond_to do |format|
      format.html #result.html.haml
      format.json { head :no_content }
    end
  end

  def all_results
    @total_bug_reports = Experiment.all.map{|e| e.bug_reports.map{|b| b.used? ? 1:0}.reduce(:+)}.reduce(:+)
    @total_invitations = Experiment.all.map{|e| e.participants.where(:is_email_sent => true).count}.reduce(:+)
    @lex_invitations = Experiment.all.map{|e| e.participants.where(:is_email_sent => true, :summary_assigned => 'lexrank').count}.reduce(:+)
    @email_invitations = Experiment.all.map{|e| e.participants.where(:is_email_sent => true, :summary_assigned => 'email').count}.reduce(:+)
    @total_accessed = Experiment.all.map{|e| e.participants.where("eval_started_at IS NOT NULL and eval_started_at != ''").count}.reduce(:+)
    @lex_accessed = Experiment.all.map{|e| e.participants.where("summary_assigned = 'lexrank' and eval_started_at IS NOT NULL and eval_started_at != ''").count}.reduce(:+)
    @email_accessed = Experiment.all.map{|e| e.participants.where("summary_assigned = 'email' and eval_started_at IS NOT NULL and eval_started_at != ''").count}.reduce(:+)
    @all_submissions = Participant.where("eval_submitted_at IS NOT NULL and eval_submitted_at != ''")
    @lex_submissions = @all_submissions.where(:summary_assigned => 'lexrank')
    @email_submissions = @all_submissions.where(:summary_assigned => 'email')

    @q1_lex = populate_result(@lex_submissions, 'lex')
    @q1_email = populate_result(@email_submissions, 'email')
    @q4 = q4_result(@all_submissions)

    respond_to do |format|
      format.html #result.html.haml
      format.json { head :no_content }
    end
  end

  def export_results_for
    experiment = Experiment.find(params[:id])

    csv_string = CSV.generate do |csv|
      cols = ["experiment","user_id","summary","question","choice"]
      csv << cols
      csv = experiment_csv(experiment, csv)
    end
    filename = "#{experiment.title}-data-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)  
  end

  def export_results_for_all
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

  def export_bug_summaries_for
    experiment = Experiment.find(params[:id])
    csv_string = CSV.generate do |csv|
      cols = ["experiment","user_id","bug_id","sentence_id","is_in_user_summary","is_in_lex_summary","is_in_email_summary"]
      csv << cols
      csv = bug_summaries_csv(experiment, csv)
    end
    filename = "#{experiment.title}-summaries-comp-data-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end

  def export_bug_summaries_for_all
    csv_string = CSV.generate do |csv|
      cols = ["experiment","user_id","bug_id","sentence_id","is_in_user_summary","is_in_lex_summary","is_in_email_summary"]
      csv << cols
      Experiment.all.each do |experiment|
        csv = bug_summaries_csv(experiment, csv)        
      end
    end
    filename = "all-summaries-comp-data-#{Time.now.to_date.to_s}.csv"
    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end

  private

  def bug_summaries_csv experiment, csv
    all_submissions = experiment.participants.where('eval_submitted_at IS NOT NULL and eval_submitted_at != ""')
    all_submissions.each do |p|
      br = p.bug_report
      rep_part = [experiment.title, p.id, br.id]
      br.comments.each do |c|
        c.sentences.each do |s|
          unless s.text.strip.empty?
            is_in_user_summary = p.sentence_evaluations.where(:sentence_id => s.id).first.importance == 1 ? true : false
            csv << rep_part + [s.id, is_in_user_summary, s.is_in_lex_summary, s.is_in_email_summary]
          end
        end
      end
    end
    return csv
  end

  def experiment_csv experiment, csv
    all_submissions = experiment.participants.where('eval_submitted_at IS NOT NULL and eval_submitted_at != ""')
    lex_submissions = all_submissions.where(:summary_assigned => 'lexrank')
    email_submissions = all_submissions.where(:summary_assigned => 'email')
    csv = submission_csv(experiment.title, lex_submissions, 'lex', csv)
    csv = submission_csv(experiment.title, email_submissions, 'email', csv)
    return csv
  end

  def submission_csv exp_title, submissions, str, csv
    submissions.each do |p|
      r = p.response
      rep_part = [exp_title, p.id, p.summary_assigned]
      csv << rep_part + ['1a', r.send("imp_points_incl_#{str}_sum")] unless r.send("imp_points_incl_#{str}_sum").blank?
      csv << rep_part + ['1b', r.send("redundancy_#{str}_sum")] unless r.send("redundancy_#{str}_sum").blank?
      csv << rep_part + ['1c', r.send("unnecessary_info_#{str}_sum")] unless r.send("unnecessary_info_#{str}_sum").blank?
      csv << rep_part + ['1d', r.send("coherence_#{str}_sum")] unless r.send("coherence_#{str}_sum").blank?
      csv << rep_part + ['4a', r.sum_help_bug_similar] unless r.sum_help_bug_similar.blank?
      csv << rep_part + ['4b', r.sum_help_bug_workaround] unless r.sum_help_bug_workaround.blank?
      csv << rep_part + ['4c', r.sum_help_bug_status] unless r.sum_help_bug_status.blank?
      csv << rep_part + ['4d', r.sum_help_bug_life] unless r.sum_help_bug_life.blank?
      csv << rep_part + ['4e', r.sum_help_proj_cont] unless r.sum_help_proj_cont.blank?
      csv << rep_part + ['4f', r.sum_help_dev] unless r.sum_help_dev.blank?
      csv << rep_part + ['4g', r.sum_help_non_dev] unless r.sum_help_non_dev.blank?
      csv << rep_part + ['5', r.summary_view_pref] #unless r.summary_view_pref.blank?
      csv << rep_part + ['contact', r.contact_for_results] #unless r.contact_for_results.blank?
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

  def q4_result submissions
    result = {:q4a => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :q4b => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :q4c => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :q4d => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :q4e => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :q4f => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0},
      :q4g => {:r0 => 0, :r1 => 0, :r2 => 0, :r3 => 0, :r4 => 0}
    }
    submissions.each do |p|
      r = p.response
      result[:q4a]["r#{r.sum_help_bug_similar}".to_sym] += 1 unless r.sum_help_bug_similar.blank?
      result[:q4b]["r#{r.sum_help_bug_workaround}".to_sym] += 1 unless r.sum_help_bug_workaround.blank?
      result[:q4c]["r#{r.sum_help_bug_status}".to_sym] += 1 unless r.sum_help_bug_status.blank?
      result[:q4d]["r#{r.sum_help_bug_life}".to_sym] += 1 unless r.sum_help_bug_life.blank?
      result[:q4e]["r#{r.sum_help_proj_cont}".to_sym] += 1 unless r.sum_help_proj_cont.blank?
      result[:q4f]["r#{r.sum_help_dev}".to_sym] += 1 unless r.sum_help_dev.blank?
      result[:q4g]["r#{r.sum_help_non_dev}".to_sym] += 1 unless r.sum_help_non_dev.blank?
    end
    return result
  end
end
