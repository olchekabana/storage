class ScheduleController < ApplicationController
  before_filter :set_sort_schedule, :check_auth, :my_name
  
  # Временный костыль, пока не откорректирован document_controller.rb и партиал header
  #@fio = session[:my_name]
  
  # Список работ и этапов разработки
  def stages
    @fio = session[:my_name]
    contracts_list = WorksDog.contracts(cookies[:sort_schedule])
    stageless_list = WorksDog.stageless_contracts(cookies[:sort_schedule])
    # Временная сортировка без совместного учета stages_dog.date_stop и works_dog.date_stop для заданий без этапа
    list = contracts_list | stageless_list
    if list.empty?
      render :template => ""
    else
      @contracts = WorkSubWork.select("id_work, name_small").ordered_by_array(list)
      @stages = WorksDog.stages_list(cookies[:sort_schedule])
      @tasks = WorksDog.stageless_list(cookies[:sort_schedule])
    end
  end
  
  # Персональные задачи
  def tasks
    @fio = session[:my_name]
    
  end
end