class WorksDog < ActiveRecord::Base
  include CalcDate
# Рабочие задания
#
#
  
  # attr_accessible :title, :body
  belongs_to :stages_dog, :foreign_key => "id_stages_dog"
  belongs_to :work_sub_work, :foreign_key => "id_work"
  belongs_to :user, :foreign_key => "id_manag", :select => "fio"
  #belongs_to :users, :foreign_key => "id_isp"
  
  # Защита от внезапного перименования полей бд
  #default_scope where("id_isp = ?", user_id)
  #session[:user_id])
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
  
  def self.personal(user_id)
    where("id_isp = ?", user_id)
  end
  
  def self.contracts_reserve(user_id, type=1)
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
  
  def self.contracts(user_id, type=1)
    list = self.stages(user_id, type)
    stages = StagesDog.id_in_array(list).group_works
    works = stages.map{|x| x.work_id} unless stages.nil?
    return works || []
  end
  
  # Поиск заданий без этапов
  def self.search_stageless(user_id, type=1)
    type = type.to_i
    # тип фильтрации
    # 1 - не завершенные
    # 2 - завершенные
    # 3 - все
    if type == 1 || type == 2
      works = self.where("status < 3").personal(user_id).stageless.group_works
    end
    if type == 3
      works = self.stageless.personal(user_id).group_works
    end
    if type == 2
      works_completed = self.where("status = 3").personal(user_id).stageless.group_works
      works = works_completed - (works_completed & works)
    end
    return works || []
  end
  
  # Список работ с заданиями не привязанными к этапам, упорядоченными по их срокам сдачи
  def self.stageless_contracts(user_id, type=1)
    works = WorksDog.search_stageless(user_id, type)
    works.map!{|x| x.work_id} unless works.empty?
    return works || []
  end
  
  # Массив заданий без этапа разбитых по work_id
  def self.stageless_list(user_id, type=1)
    works = self.search_stageless(user_id, type)
    tasks = works.group_by{|s| s.work_id} unless works.empty?
    return tasks || Hash.new
  end
  
  # Метод тут потому что прогресс выполнения высчитывается по заданиям
  # Выборка id этапов в соответствии с фильтром
  # Необязательное значение по умолчанию, присвоение кукисов с типом сортировки в before_filter
  def self.stages(user_id, type=1)
    type = type.to_i
    # тип фильтрации
    # 1 - не завершенные
    # 2 - завершенные
    # 3 - все
    if type == 1 || type == 2
      stages = self.select_stages.where("status < 3").personal(user_id).group_stages
    end
    if type == 3
      stages = self.select_stages.personal(user_id).group_stages
    end
    stages.map!{|x| x.stage_id} unless stages.nil?
    if type == 2
      stages_completed = self.select_stages.where("status = 3").personal(user_id).group_stages
      stages_completed.map!{|x| x.stage_id} unless stages_completed.nil?
      stages = stages_completed - (stages_completed & stages)
    end
    return stages || []
  end
  
  # Массив этапов разбитых по work_id
  def self.stages_list(user_id, type=1)
    list = self.stages(user_id, type)
    stages = StagesDog.id_in_array(list)
    unless stages.empty?
      stages.sort_by!{|s| [s.date_stop, s.id]}
      stages_list = stages.group_by{|s| s.work_id}
    end
    return stages_list || []
  end
  
  def self.staged(user_id, stage_id)
    where("works_dog.id_stages_dog = ?", stage_id).personal(user_id).joins(:user).order("works_dog.date_stop")
  end
  
  def self.where_status(type=1)
    type = type.to_i
    if type == 1
      return where("status < 3")
    end
    if type == 2
      return where("status = 3")
    end
    if type == 3
      return where("")
    end
  end
  
  def self.tasks_list(user_id, id, type)
    type = type.to_i
    # тип фильтрации
    # 1 - не завершенные
    # 2 - завершенные
    # 3 - все
    if type == 1 || type == 2
      tasks = self.where("works_dog.status < 3 AND works_dog.id_work = ?", id).personal(user_id).joins(:user).order("works_dog.id_stages_dog, works_dog.date_stop")
    end
    if type == 2
      tasks = self.where("works_dog.status = 3 AND works_dog.id_work = ?", id).personal(user_id).joins(:user).order("works_dog.id_stages_dog, works_dog.date_stop")
      # tasks_completed = self.where("works_dog.status = 3 AND works_dog.id_work = ?", id).joins(:user).order("works_dog.id_stages_dog, works_dog.date_stop")
      # tasks = tasks_completed - (tasks_completed & tasks)
    end
    if type == 3
      tasks = self.where("works_dog.id_work = ?", id).personal(user_id).joins(:user).order("works_dog.id_stages_dog, works_dog.date_stop")
    end
    tasks = tasks.group_by{|t| t.stage_id} unless tasks.empty?
    return tasks || []
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
