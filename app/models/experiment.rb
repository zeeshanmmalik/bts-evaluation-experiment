require 'exceptions'
class Experiment < ActiveRecord::Base
  has_many :participants, :dependent => :destroy
  has_many :bug_reports, :dependent => :destroy
  has_many :emails, :dependent => :destroy

  def email(e_type)
    email = emails.where(:email_type => e_type).first
    raise Exceptions::EmailDoesNotExist.new("#{e_type.humanize} email for experiment '#{title}' does NOT exist!") unless email
    email
  end

  
end
