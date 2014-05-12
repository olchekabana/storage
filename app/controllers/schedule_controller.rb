class ScheduleController < ApplicationController
  include ActionView::Helpers::TextHelper
  respond_to :html, :js
  before_filter :set_sort_schedule, :check_auth, :my_name, :unuthed
  
  # Временный костыль, пока не откорректирован document_controller.rb и партиал header
  #@fio = session[:my_name]
  
  # Список работ и этапов разработки
  def stages
    @fio = session[:my_name]
    contracts_list = WorksDog.contracts(session[:user_id], cookies[:sort_stages])
    stageless_list = WorksDog.stageless_contracts(session[:user_id], cookies[:sort_stages])
    # Временная сортировка без совместного учета stages_dog.date_stop и works_dog.date_stop для заданий без этапа
    list = contracts_list | stageless_list
    @list = contracts_list
    if list.empty?
      render :template => "shared/not_found"
    else
      @contracts = WorkSubWork.select("id_work, name_small").ordered_by_array(list)
      @stages = WorksDog.stages_list(session[:user_id], cookies[:sort_stages])
      @tasks = WorksDog.stageless_list(session[:user_id], cookies[:sort_stages])
    end
  end 
  
  # Персональные задачи
  def tasks
    @fio = session[:my_name]
    case
    when params[:stage_id] == "0"
      @tasks = WorksDog.where("id_work = ?", params[:id]).where_status(cookies[:sort_tasks]).personal(session[:user_id]).stageless
      work = WorkSubWork.find(params[:id])
      @work_name = work.name_small
    when (params[:stage_id] == "" or params[:stage_id].nil?)
      @tasks = WorksDog.tasks_list(session[:user_id], params[:id], cookies[:sort_tasks])
      @stages = StagesDog.where("id_work = ?", params[:id]).order(:date_stop)
      work = WorkSubWork.find(params[:id])
      @work_name = work.name_small
    else
      @stage = StagesDog.joins(:work_sub_work).find(params[:stage_id])
      @tasks = WorksDog.staged(session[:user_id], params[:stage_id]).where_status(cookies[:sort_tasks])
      @work_name = @stage.work_sub_work.name_small
    end
    if @tasks.empty?
      render :template => "shared/not_found"
    end
  end
  
  def sorting_stages
    cookies[:sort_stages] = params[:id]
    redirect_to :back
  end
  
  def sorting_tasks
    cookies[:sort_tasks] = params[:id]
    redirect_to :back
  end
  
  def update_status
    @task = WorksDog.find(params[:task][:id])
    unless params[:set_status] == "true"
      @task.result = strip_tags(params[:task][:result])
    end
    @task.status += 1
    @task.save
    respond_to do |format|
      format.js
    end
  end
end
 