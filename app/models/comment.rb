class Comment < ActiveRecord::Base
  belongs_to :participant
  belongs_to :bug_report
  has_many :sentences, :dependent => :destroy
end
