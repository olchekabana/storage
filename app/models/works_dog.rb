class WorksDog < ActiveRecord::Base
# Рабочие задания
#
#
  
  # attr_accessible :title, :body
  belongs_to :stages_dog, :foreign_key => "id_stages_dog"
  belongs_to :users, :foreign_key => "id_isp"
  belongs_to :work_sub_works, :foreign_key => "id_work"
  belongs_to :users, :foreign_key => "id_manag"
  
  # Защита от внезапного перименования полей бд
  # default_scope where("id_isp = ?", session[:user_id])
  scope :ord_stage_status, joins(:stages_dog).order("stages_dog.date_stop")
  scope :jgroup_works, group("works_dog.id_work")
  scope :jselect_works, select("works_dog.id_work")
  
  scope :group_stages, group(:id_stages_dog)
  scope :group_works, group(:id_work)
  scope :select_stages, select(:id_stages_dog) 
  scope :select_works, select(:id_work)
  
  scope :stageless, where("id_stages_dog = 0").order("date_stop")
  #scope :contracts, select(:id_work).order(:date_stop).group(:id_work)
  
  # Метод тут потому что прогресс выполнения высчитывается по заданиям
  # Выборка id работ в соответствии с фильтром
  # Необязательное значение по умолчанию, присвоение кукисов с типом сортировки в before_filter
  def self.contracts(type=1)
    type = type.to_i
    # тип фильтрации
    # 1 - не завершенные
    # 2 - завершенные
    # 3 - все
    if type == 1 || type == 2
      works = self.jselect_works.where("works_dog.status < 3").ord_stage_status.jgroup_works
    end
    if type == 3
      works = self.jselect_works.ord_stage_status.jgroup_works
    end
    works.map!{|x| x.work_id} unless works.nil?
    if type == 2
      works_completed = self.jselect_works.where("works_dog.status = 3").ord_stage_status.jgroup_works
      works_completed.map!{|x| x.work_id} unless works_completed.nil?
      works = works_completed - (works_completed & works)
    end
    return works || []
  end
  
  # Поиск заданий без этапов
  def self.search_stageless(type=1)
    type = type.to_i
    # тип фильтрации
    # 1 - не завершенные
    # 2 - завершенные
    # 3 - все
    if type == 1 || type == 2
      works = self.where("status < 3").stageless.group_works
    end
    if type == 3
      works = self.stageless.group_works
    end
    if type == 2
      works_completed = self.where("status = 3").stageless.group_works
      works = works_completed - (works_completed & works)
    end
    return works || []
  end
  
  # Список работ с заданиями не привязанными к этапам, упорядоченными по их срокам сдачи
  def self.stageless_contracts(type=1)
    works = WorksDog.search_stageless(type)
    works.map!{|x| x.work_id} unless works.empty?
  end
  
  # Массив заданий без этапа разбитых по work_id
  def self.stageless_list(type=1)
    works = self.search_stageless(type)
    tasks = works.group_by{|s| s.work_id} unless works.empty?
    return tasks || []
  end
  
  # Метод тут потому что прогресс выполнения высчитывается по заданиям
  # Выборка id этапов в соответствии с фильтром
  # Необязательное значение по умолчанию, присвоение кукисов с типом сортировки в before_filter
  def self.stages(type=1)
    type = type.to_i
    # тип фильтрации
    # 1 - не завершенные
    # 2 - завершенные
    # 3 - все
    if type == 1 || type == 2
      stages = self.select_stages.where("status < 3").group_stages
    end
    if type == 3
      stages = self.select_stages.group_stages
    end
    stages.map!{|x| x.stage_id} unless stages.nil?
    if type == 2
      stages_completed = self.select_stages.where("status = 3").group_stages
      stages_completed.map!{|x| x.stage_id} unless stagstages_completedes.nil?
      stages = stages_completed - (stages_completed & stages)
    end
    return stages || []
  end
  
  # Массив этапов разбитых по work_id
  def self.stages_list(type=1)
    list = self.stages(type)
    stages = StagesDog.id_in_array(list)
    unless stages.empty?
      stages.sort_by!{|s| [s.date_stop, s.id]}
      stages_list = stages.group_by{|s| s.work_id}
    end
    return stages_list || []
  end
  
  # Более удобные методы обращения к полям таблицы
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
