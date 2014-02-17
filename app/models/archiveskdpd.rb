class Archiveskdpd < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :documents
  
  scope :extended, includes(:documents)
  
  def self.ordered()
	first = Archiveskdpd.where('sub_id = ?', 0).order('name').pluck(:id)
	aux = Archiveskdpd.select('id, sub_id').where('sub_id > ?', 0).order('name')
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
	works = Archiveskdpd.order('name').all
	a = Hash.new
	works.each do |work|
		a[work.id] = work.sub_id
	end
	
	b = Hash.new
	works.each do |work|
		unless b.key? work.sub_id
			b[work.sub_id] = Array.new
		end
		b[work.sub_id] << work.id
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
	contracts = Archiveskdpd.order('name').all
	a = Hash.new
	b = Hash.new
	contracts.each do |contract|
		a[contract.id] = contract.sub_id
		b[contract.id] = contract.name
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
