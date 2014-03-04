class StagesDog < ActiveRecord::Base
  #attr_accessible :title, :body
  belongs_to :work_sub_works, :foreign_key => "id_work"
  has_many :works_dog, :foreign_key => "id_stages_dog"
  
  #def name
  def index
    self[:name_stage]
  end
  
  #def work_name
  def name
    self[:name_work_stage]
  end
  
  def work_id
    self[:id_work]
  end
  
end
