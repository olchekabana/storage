class Document < ActiveRecord::Base
  # attr_accessible :title, :body
  #attr :path_file
  belongs_to :work_sub_work, :foreign_key => 'id_work'
  belongs_to :archive
  belongs_to :standart
  
  def can_see
	file = self[:path_file].split('.')
	ext = file.pop
	val = ""
	val = "cant" unless ["jpeg", "gif", "png", "svg", "pdf"].include?(ext)
  end
  
  def path_file_ed
	file = self[:path_file].split('.')
	ext = file.pop
	file.join('.')+" (#{ext})"
  end
  
  
  
end
