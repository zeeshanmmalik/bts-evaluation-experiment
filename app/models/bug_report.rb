class BugReport < ActiveRecord::Base
  belongs_to :experiment
  has_many :participants
  has_many :comments, :dependent => :destroy
  has_many :responses, :dependent => :destroy

  default_scope :select => "bug_reports.*, (select count(comments.id) from comments where comments.bug_report_id = bug_reports.id) as count_comments"

  def used?
    participants.where(:is_email_sent => true).count > 0
  end

  def submissions
    participants.where("eval_submitted_at IS NOT NULL and eval_submitted_at != ''").count unless participants.blank?
  end
end
