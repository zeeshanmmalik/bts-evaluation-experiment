class Experiment < ActiveRecord::Base
  has_many :participants, :dependent => :destroy
  has_many :bug_reports, :dependent => :destroy
  has_many :emails, :dependent => :destroy

  def email(e_type)
    emails.where(:email_type => e_type).first
  end

  
end
