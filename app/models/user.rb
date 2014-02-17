class User < ActiveRecord::Base
  # attr_accessible :title, :body
  
  def self.give_me_access(id)
	User.find(id).pr_admin
  end
  
  def self.give_me_name(id)
	User.find(id).fio
  end
  
  def self.access(id)
	if id
		if User.exists?(id) then User.give_me_access(id) else nil end
	else
		-1
	end
  end
end
