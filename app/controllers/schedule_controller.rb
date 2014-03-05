class ScheduleController < ApplicationController
  before_filter :set_sort_schedule, :check_auth, :my_name
  
  # Временный костыль, пока не откорректирован document_controller.rb и партиал header
  #@fio = session[:my_name]
  
  # Список работ и этапов разработки
  def stages
    @fio = session[:my_name]
    contracts_list = WorksDog.contracts(cookies[:sort_schedule])
    if contracts_list.length == 0
      render :template => ""
    else
      @contracts = WorkSubWork.select("id_work, name_small").ordered_by_array(contracts_list)
      stages_list = WorksDog.stages(cookies[:sort_schedule])
      stages = StagesDog.ordered_by_array(stages_list)
      @stages = stages.sort_by{|s| [(contracts_list.index s.work_id), s.date_stop, s.id]}
    end
  end
  
  # Персональные задачи
  def tasks
    
  end
end
