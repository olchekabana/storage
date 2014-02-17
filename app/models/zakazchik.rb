class Zakazchik < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :work_sub_works
end
