class WorksDog < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :stages_dog, :foreign_key => "id_stages_dog"
  belongs_to :users, :foreign_key => "id_isp"
  belongs_to :work_sub_works, :foreign_key => "id_work"
  belongs_to :users, :foreign_key => "id_manag"
  
  scope :contracts, select(:id_work).order(:date_stop).group(:id_work)
  
  def stage_id
    self[:id_stages_dog]
  end
  
  def work_id
    self[:id_work]
  end
  
  def index
    self[:index_work]
  end
  
  def name
    self[:name_work]
  end
  
  def manager_id
    self[:id_manag]
  end
  
  def user_id
    self[:id_isp]
  end

end
