class CreateWorksDogs < ActiveRecord::Migration
  def change
    create_table :works_dogs, :primary_key => :id_work_dog do |t|
      t.integer :id_stages_dog
      t.integer :id_work
      t.string :index_work, :limit => 45
      t.string :name_work, :limit => 245
      t.text :comment
      t.datetime :date_stop
      t.datetime :date_start
      t.integer :procents
      t.integer :id_isp
      t.integer :id_manag
      t.integer :status
      t.datetime :date_done
      t.text :result
    end
  end
end
