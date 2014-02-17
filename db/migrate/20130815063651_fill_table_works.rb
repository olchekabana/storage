class FillTableWorks < ActiveRecord::Migration
  def up
	arr = WorkSubWork.where("id_sub_work = ?", 0)
	arr.each do |a|
		tree = WorkSubWork.tree(a.id_work)
		sub_arr = WorkSubWork.where(:id_work => tree)
		sub_arr.each do |b|
			if b.id_otdel == 0 || b.id_zakazchik == 0 || b.id_manager == 0
				if b.id_otdel == 0
					b.id_otdel = a.id_otdel
				end
				if b.id_zakazchik == 0
					b.id_zakazchik = a.id_zakazchik
				end
				if b.id_manager == 0
					b.id_manager = a.id_manager
				end
				b.save
			end
		end
	end
  end

  def down
  end
end
