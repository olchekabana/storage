class CreateStagesDogs < ActiveRecord::Migration
  def change
    create_table :stages_dogs, :primary_key => :id_stages_dog do |t|
      t.integer :id_work
      t.string :name_stage, :limit => 145
      t.string :name_work_stage, :limit => 245
      t.text :comment
      t.datetime :date_stop
      t.datetime :date_start
      t.integer :stage_proc
    end
  end
end
