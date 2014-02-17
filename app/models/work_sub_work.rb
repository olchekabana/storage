class WorkSubWork < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :zakazchik, :foreign_key => 'id_zakazchik'
  belongs_to :manager, :foreign_key => 'id_manager'
  belongs_to :otdel_dfct, :foreign_key => 'id_otdel'
  has_many :documents, :foreign_key => 'id_work'
  has_and_belongs_to_many :work_sub_works, :join_table=> 'work_sub_works', :foreign_key => 'id_sub_work', :association_foreign_key => 'id_work'
  
  scope :extended, includes(:documents)
  #.joins('LEFT OUTER JOIN zakazchik ON zakazchik.id_zakazchik = work_sub_works.id_zakazchik').joins('LEFT OUTER JOIN managers ON managers.id_manager = work_sub_works.id_manager').joins('LEFT OUTER JOIN otdel_dfct ON otdel_dfct.id_otdel = work_sub_works.id_otdel')
  #.joins(:zakazchik, :otdel_dfct, :manager)
  
  def start
	self[:date_start].strftime("%d.%m.%Y") || '-'
  end
  
  def stop
	self[:date_stop].strftime("%d.%m.%Y") || '-'
  end
  
  def self.ordered(param, cond=Hash.new)
	cond[:id_sub_work] = 0
	if param == '3'
		first = WorkSubWork.joins('LEFT OUTER JOIN otdel_dfct ON otdel_dfct.id_otdel = work_sub_works.id_otdel').where(cond).order('otdel_dfct.name_small, work_sub_works.name_small').pluck(:id_work)
		aux = WorkSubWork.select('id_work, id_sub_work').where('id_sub_work > ?', 0).joins('LEFT OUTER JOIN otdel_dfct ON otdel_dfct.id_otdel = work_sub_works.id_otdel').order('otdel_dfct.name_small, work_sub_works.name_small')
	elsif param == '2'
		first = WorkSubWork.joins('LEFT OUTER JOIN managers ON managers.id_manager = work_sub_works.id_manager').where(cond).order('managers.fio, work_sub_works.name_small').pluck(:id_work)
		aux = WorkSubWork.select('id_work, id_sub_work').where('id_sub_work > ?', 0).joins('LEFT OUTER JOIN managers ON managers.id_manager = work_sub_works.id_manager').order('managers.fio, work_sub_works.name_small')
	else
		first = WorkSubWork.joins('LEFT OUTER JOIN zakazchik ON zakazchik.id_zakazchik = work_sub_works.id_zakazchik').where(cond).order('zakazchik.name_small, work_sub_works.name_small').pluck(:id_work)
		aux = WorkSubWork.select('id_work, id_sub_work').where('id_sub_work > ?', 0).joins('LEFT OUTER JOIN zakazchik ON zakazchik.id_zakazchik = work_sub_works.id_zakazchik').order('zakazchik.name_small, work_sub_works.name_small')
	end
	sub_hash = Hash.new
	aux.each do |a|
		unless sub_hash.key? a.id_sub_work
			sub_hash[a.id_sub_work] = Array.new
		end
		sub_hash[a.id_sub_work] << a.id_work
	end
	
	i = 1
	a = Array.new
	first.each do |fst|
		if sub_hash.key? fst
			first.insert(i, sub_hash[fst])
			first.flatten!
		end
		i += 1
	end
	
	return first
  end
  
  def self.tree(id)
	id = id.to_i
	works = WorkSubWork.select('id_work, id_sub_work').order('name_small').all
	a = Hash.new
	works.each do |work|
		a[work.id_work] = work.id_sub_work
	end
	
	b = Hash.new
	works.each do |work|
		unless b.key? work.id_sub_work
			b[work.id_sub_work] = Array.new
		end
		b[work.id_sub_work] << work.id_work
	end
	
	until a[id] == 0
		id = a[id]
	end
	
	i = 1
	result = Array.new
	result << id
	result.each do |res|
		if b.key? res
			result.insert(i, b[res])
			result.flatten!
		end
		i += 1
	end
	
	return result
  end
  
  def self.tree_hashes
	works = WorkSubWork.select('id_work, id_sub_work, name_small').order('name_small').all
	a = Hash.new
	b = Hash.new
	works.each do |work|
		a[work.id_work] = work.id_sub_work
		b[work.id_work] = work.name_small
	end
	
	c = Array.new
	c.push(a)
	c.push(b)
	return c
  end
  
  def tree_name(c)
	id = self[:id]
	name = ""
	until c[0][id] == 0
		name = c[1][id] + "/" + name
		id = c[0][id]
	end
	name = c[1][id] + "/" + name
	return name.chop!
  end
  
end
