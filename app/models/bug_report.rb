class BugReport < ActiveRecord::Base
  belongs_to :experiment
  has_many :participants
  has_many :comments, :dependent => :destroy
  has_many :responses, :dependent => :destroy

  default_scope :select => "bug_reports.*, (select count(comments.id) from comments where comments.bug_report_id = bug_reports.id) as count_comments"
end
