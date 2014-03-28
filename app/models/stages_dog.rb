class StagesDog < ActiveRecord::Base
  include CalcDate
  
  #attr_accessible :title, :body
  belongs_to :work_sub_work, :foreign_key => "id_work"
  has_many :works_dog, :foreign_key => "id_stages_dog"
  
  # Защита от внезапного перименования полей бд
  scope :group_stages, group(:id)
  scope :group_works, group(:id_work)
  scope :select_stages, select(:id)
  scope :select_works, select(:id_work)
  
  def self.ordered_by_array(arr)
    order("field(id_stages_dog, #{arr.join(',')})").where(:id_stages_dog => arr)
  end
  
  def self.id_in_array(arr)
    where(:id_stages_dog => arr)
  end
  
  # Более удобные методы обращения к полям таблицы
  # дней до сдачи проекта
  def days_remain
    (self[:date_stop].to_date - Date.today).to_i
  end
  
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
