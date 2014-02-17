class Standart < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :documents
  
  scope :extended, includes(:documents)
  
  def self.ordered()#id)
	#id = id.to_i
	first = Standart.where('sub_id = ?', 0).pluck(:id)
	#first = Standart.where('sub_id = ?', id).order('name').pluck(:id)
	aux = Standart.select('id, sub_id').where('sub_id > ?', 0).order('id')
	sub_hash = Hash.new
	aux.each do |a|
		unless sub_hash.key? a.sub_id
			sub_hash[a.sub_id] = Array.new
		end
		sub_hash[a.sub_id] << a.id
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
	standards = Standart.select('id, sub_id').order('name').all
	a = Hash.new
	standards.each do |standard|
		a[standard.id] = standard.sub_id
	end
	
	b = Hash.new
	standards.each do |standard|
		unless b.key? standard.sub_id
			b[standard.sub_id] = Array.new
		end
		b[standard.sub_id] << standard.id
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
	standards = Standart.order('name').all
	a = Hash.new
	b = Hash.new
	standards.each do |standard|
		a[standard.id] = standard.sub_id
		b[standard.id] = standard.name
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
