begin
  namespace :experiment do
    task :load_bug_reports => :environment do
      if ENV['title'].nil?
        abort "Title of the experiment not provided.\nUsage: rake experiment:load_bug_reports title=<title of experiment/study>"
      end
      if File.directory?("#{Rails.root}/bug-reports-data")
        # create a new experiment
        exp = Experiment.new :title => ENV['title']
        exp.save!
        Dir["#{Rails.root}/bug-reports-data/*"].each do |bug_rep_json|
          # discard files created by editors like emacs
          if not bug_rep_json =~ /^(\.|#)|(~|#)$/
            brj = File.read(bug_rep_json)
            #puts "******************************************************"
            #puts brj
            #puts "******************************************************"
            begin
              brj_hash = JSON.parse(brj)
              #puts "#####################################################"
              #puts brj_hash
              #puts "#####################################################"
              # create new bug_report
              bug_report = BugReport.new(:title => brj_hash['title'],
                                         :project => brj_hash['project'],
                                         :original_link => brj_hash['original_link'])
              bug_report.experiment = exp
              bug_report.save!
              brj_hash['comments'].each_with_index do |com, com_num|
                # create or retrieve participant
                participant = Participant.find_or_create_by_email :email => com['email']
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
            rescue Exception => e
              puts "#{bug_rep_json}: Invalid JSON. Please verify and correct the content of the file e.g: at jsonlint.com"
            end
          end
        end
		puts "Experiment: #{exp.title}"
		puts "Total Bug Reports: #{exp.bug_reports.count}"
        puts "Total Participants: #{exp.participants.count}"
      else
        abort "bug-reports-data directory does not exists"
      end
    end
  end
end


