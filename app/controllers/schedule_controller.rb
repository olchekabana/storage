class ScheduleController < ApplicationController
  respond_to :html, :js
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
    case
    when params[:stage_id] == "0"
      @tasks = WorksDog.where("id_work = ?", params[:id]).stageless
      work = WorkSubWork.find(params[:id])
      @work_name = work.name_small
    when (params[:stage_id] == "" or params[:stage_id].nil?)
      @tasks = WorksDog.tasks_list(params[:id], 3)
      @stages = StagesDog.where("id_work = ?", params[:id]).order(:date_stop)
      work = WorkSubWork.find(params[:id])
      @work_name = work.name_small
    else
      @stage = StagesDog.joins(:work_sub_work).find(params[:stage_id])
      @tasks = WorksDog.staged(params[:stage_id])
      @work_name = @stage.work_sub_work.name_small
    end
    
  end
  
  def update_status
    @task = WorksDog.find(params[:task][:id])
    if params[:set_status] == "true"
      # if
      
    else
      @task.result = params[:task][:result]
    end
    @task.status += 1
    @task.save
    respond_to do |format|
      format.js
    end
  end
end
 