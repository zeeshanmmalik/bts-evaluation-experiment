require 'csv'
begin
  namespace :experiment do
    task :load_bug_reports => :environment do
      error = "!!TASK ABORTED!!\n"
      exp_title = ENV['title']
      br_dir = ENV['dir']
      if exp_title.blank? || br_dir.blank?
        error += "Missing or invalid required arguments.\n"\
                 "Usage: rake experiment:load_bug_reports "\
                 "title=<title of experiment> dir=<directory from which to load bug reports in json file>\n"\
                 "dir: Path is relative to root directory of Rails app which is #{Rails.root}"
        abort error
      end
      unless File.directory?("#{Rails.root}/#{br_dir}")
        error += "#{Rails.root}/#{br_dir}: directory does not exists!"
        abort error
      end

      # create a new experiment
      exp = Experiment.find_or_create_by_title :title => exp_title
      Dir["#{Rails.root}/#{br_dir}/*"].each do |bug_rep_json|
        # discard files created by editors like emacs
        if not bug_rep_json =~ /^(\.|#)|(~|#)$/
          brj = File.read(bug_rep_json)
          begin
            brj_hash = JSON.parse(brj)
            # create new bug_report
            unless exp.bug_reports.exists?(:bug_identifier => brj_hash['id'], :project => brj_hash['project'])
              create_bug_report(exp, brj_hash)
            end
          rescue Exception => e
            puts e.message
            puts "#{bug_rep_json}: Invalid JSON. Please verify and correct the content of the file e.g: at jsonlint.com"
          end
        end
      end
      puts "Experiment: #{exp.title}"
      puts "Total Bug Reports: #{exp.bug_reports.count}"
      puts "Total Participants: #{exp.participants.count}"
    end

    task :send_invitation_emails => :environment do
      if ENV['exp_title'].blank? or ENV['already_sent'].blank? or ENV['total'].blank? or
          not ENV['already_sent'] =~ /^(true|false)$/ or
          not ENV['total'].to_i > 0
        abort "! TASK ABORTED !\nMissing or invalid required arguments.\nUsage: rake experiment:send_invitation_emails exp_title=<title of experiment> already_sent=<true/false> total=<no. of participants to send email to>\nexp_title: non empty string\nalready_sent: true/false\ntotal: a positive number"
      end
      already_sent = ENV['already_sent'] == 'true' ? true : false
      total = ENV['total'].to_i
      exp = Experiment.find_by_title(ENV['exp_title'])
      if exp.nil?
        abort "Experiment titled '#{ENV['exp_title']}' not found!"
      end
      participants = exp.participants.where("is_email_sent = ? and email IS NOT NULL and email != '' and bug_report_id IS NOT NULL and access_token IS NOT NULL and access_token != ''", already_sent).limit(total)
      participants.each do |p|
        ParticipantMailer.invitation_email(p).deliver
        p.is_email_sent = true
        p.save!
      end
      puts "#{participants.count} email(s) sent."
    end

	task :assign_random_bug_reports_to_participants => :environment do
      if ENV['title'].blank?
        abort "Title of the experiment not provided.\nUsage: rake experiment:assign_bug_reports_to_participants title=<title of experiment/study>"
      end
      exp = Experiment.where(:title => ENV['title']).first
      if exp.nil?
        abort "Experiment titled '#{ENV['title']}' not found."
      end

      exp.participants.each do |p|
        rand_id = rand(exp.bug_reports.count)
        rand_bug = BugReport.first(:conditions => [ "id >= ?", rand_id])
        if rand_bug
          # access_token: <current time stamp>-<bug report id>_<alpha-numeric hex string of length 16>-<participant id> 
          p.access_token = "#{Time.new.to_time.to_i}-#{rand_bug.id}_#{SecureRandom.hex(8)}-#{p.id}"
          p.bug_report = rand_bug
          p.is_email_sent = false
          p.is_selected = true
          p.summary_assigned = rand > 0.5 ? APP_CONFIG['email_summary'] : APP_CONFIG['lex_summary']
          p.save!
        else
          puts "Random Bug Report not found."
        end
      end
    end

    task :populate_name_and_email => :environment do
      error = "!!TASK ABORTED!!\n"
      exp_title = ENV['exp_title']
      csv_file = ENV['csv_file']
      if exp_title.blank? || csv_file.blank?
        error += "Missing or invalid required arguments.\n"\
                 "Usage: rake experiment:populate_name_and_email "\
                 "exp_title=<title of experiment> csv_file=<csv file from which to load names and emails>\n"\
                 "csv_file: Path is relative to root directory of Rails app which is #{Rails.root}"
        abort error
      end
      unless File.exist?("#{Rails.root}/#{csv_file}")
        error += "#{Rails.root}/#{csv_file}: file does not exists!"
        abort error
      end

      exp = Experiment.where(:title => exp_title).first
      unless exp
        error += "Experiment with title '#{exp_title}' does not exists!"
        abort error
      end
      csv_text = File.read("#{Rails.root}/#{csv_file}")
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        row = row.to_hash.with_indifferent_access
        p = exp.participants.where(:username => row[:username]).first
        if p
          p.email = row[:email]
          p.name = row[:name]
          p.save!
        else
          puts "#{row[:username]} does not exist."
        end
      end
    end

  end

  def create_bug_report(exp, brj_hash)
    bug_report = BugReport.new(:title => brj_hash['title'],
                               :project => brj_hash['project'],
                               :original_link => brj_hash['original_link'],
                               :bug_identifier => brj_hash['id'])
    bug_report.experiment = exp
    bug_report.save!
    brj_hash['comments'].each_with_index do |com, com_num|
      # create or retrieve participant
      participant = Participant.find_or_create_by_username :username => com['name']
      participant.experiment = exp
      participant.save!
      # create new comment
      comment = Comment.new(:number => com_num,
                            :submitted_at => com['date'])
      comment.participant = participant
      comment.bug_report = bug_report
      comment.save!
      com['sentences'].to_enum.with_index(1).each do |sen, sen_num|
        # Create sentence
        sentence = Sentence.new(:text => sen['text'],
                                :is_in_lex_summary => sen['is_in_lex_summary'],
                                :is_in_email_summary => sen['is_in_email_summary'],
                                :number => sen_num)
        sentence.comment = comment
        sentence.save!
      end
    end
    # assign bug report and summry to participants
    brj_hash['contributors'].each do |con|
      participant = exp.participants.find_or_create_by_username(con[0])
      participant.bug_report = bug_report
      participant.summary_assigned = con[1]
      participant.access_token = "#{Time.new.to_time.to_i}-#{bug_report.id}_#{SecureRandom.hex(8)}-#{participant.id}"
      participant.is_selected = true
      participant.is_email_sent = false
      participant.save!
    end
  end

end


