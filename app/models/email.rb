class Email < ActiveRecord::Base
  def self.TYPES
    ['invitation','reminder','thanks','result']
  end
  belongs_to :experiment
  validates :subject, :body, :email_type, :experiment, :presence => true
  validates :email_type, :uniqueness => { :scope => :experiment_id }
end
