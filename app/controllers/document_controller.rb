class DocumentController < ApplicationController
  respond_to :html, :js
  before_filter :check_auth
  
  def switch
    
  end
  
  def filter
    @customers = Zakazchik.order("name_small").all
    @managers = Manager.order("fio").all
    @departments = OtdelDfct.order("name_small").all
    render :partial => "shared/filter"
  end

  def search
    @access = if session[:user_id] then User.access(session[:user_id]) else 0 end
    @fio = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
    #@s_menu = Standart.where("sub_id = ?", 0).order("name")
    if !params[:search].blank?
      search = "%" + params[:search] + "%"
      @contracts = WorkSubWork.extended.where("work_sub_works.name_small like ? OR work_sub_works.name_full like ?", search, search).order("work_sub_works.name_small")
      @archives = Archiveskdpd.extended.where("archiveskdpd.name like ?", search).order("archiveskdpd.name")
      @standards = Standart.extended.where("standarts.name like ?", search).order("standarts.name")
      if @contracts.size == 0 && @archives.size == 0 && @standards.size == 0
        render :template => "shared/not_found"
      else
        @a = Archiveskdpd.tree_hashes
        @s = Standart.tree_hashes
        @c = WorkSubWork.tree_hashes
      end
    end
  end

  def sorting_contracts
    cookies[:sorting_type] = params[:id]
    redirect_to :back
  end

  def sorting_standards
    cookies[:standards_id] = params[:id]
    redirect_to :action => "standards", :id => 106
  end

  # ДОГОВОРА И РКД

  def show_archive
    @access = if session[:user_id] then User.access(session[:user_id]) else 0 end
    @fio = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
    @contract = Archiveskdpd.extended.find_by_id(params[:id])
    if @contract.nil?
      render :template => "shared/not_found" and return
    end
    #@model = "archives"
    @c = Archiveskdpd.tree_hashes
  #render "show_contract"
  end

  def show_contract
    @access = if session[:user_id] then User.access(session[:user_id]) else 0 end
    @fio = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
    #@s_menu = Standart.where("sub_id = ?", 0).order("name")
    @contract = WorkSubWork.extended.find_by_id_work(params[:id])
    if @contract.nil?
      render :template => "shared/not_found"
    end
    @model = "contracts"
    @c = WorkSubWork.tree_hashes
  end

  def archives
    @fio = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
    @access = if session[:user_id] then User.access(session[:user_id]) else 0 end
    order = Archiveskdpd.ordered()
    if order.length == 0
      render :template => "shared/not_found" and return
    else
      @contracts = Archiveskdpd.extended.order("field(id, #{order.join(',')})").where(:id => order)
    end
  #@model = "archives"
  #render "contracts"
  end

  def contracts
    @fio = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
    @access = if session[:user_id] then User.access(session[:user_id]) else 0 end
    #@s_menu = Standart.where("sub_id = ?", 0).order("name")
    conditions = Hash.new
    unless params[:customers].blank? then conditions[:id_zakazchik] = params[:customers].split end
    unless params[:managers].blank? then conditions[:id_manager] = params[:managers].split end
    unless params[:departments].blank? then conditions[:id_otdel] = params[:departments].split end
    order = WorkSubWork.ordered(cookies[:sorting_type], conditions)
    if order.length == 0
      render :template => "shared/not_found"
    else
      @contracts = WorkSubWork.extended.order("field(id_work, #{order.join(',')})").where(:id_work => order)
    end
    @model = "contracts"
  end

  def archives_tree
    order = Archiveskdpd.tree(params[:id])
    @tree = Archiveskdpd.order("field(id, #{order.join(',')})").where(:id => order)
    @model = "archives"
    respond_to do |format|
      format.js
    end
  end

  def contracts_tree
    order = WorkSubWork.tree(params[:id])
    @tree = WorkSubWork.select("id_work, id_sub_work, name_small").order("field(id_work, #{order.join(',')})").where(:id_work => order)
    @model = "contracts"
    respond_to do |format|
      format.js
    end
  end

  # СТАНДАРТЫ
  def show_standard
    @fio = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
    @access = if session[:user_id] then User.access(session[:user_id]) else 0 end
    #@s_menu = Standart.where("sub_id = ?", 0).order("name")
    @standard = Standart.find_by_id(params[:id])
    if @standard.nil?
      render :template => "shared/not_found"
    end
    @c = Standart.tree_hashes
  end

  def standards
    @fio = if session[:user_id] then User.give_me_name(session[:user_id]) else "" end
    @access = if session[:user_id] then User.access(session[:user_id]) else 0 end
    #@s_menu = Standart.where("sub_id = ?", 0).order("name")
    #@lower = ""
    #if params[:id].to_i == 106
    #	@lower = "lower"
    #	@sub_stadnards = Standart.where("sub_id = ?", 106)
    #	unless cookies[:standards_id] then cookies[:standards_id] = @sub_stadnards[0].id end
    #	params[:id] = cookies[:standards_id]
    #end
    order = Standart.ordered()#params[:id])
    if order.length == 0
      render :template => "shared/not_found"
    else
      @standards = Standart.extended.order("field(id, #{order.join(',')})").where(:id => order)
    end
  end

end