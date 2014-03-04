class CreateStagesDogs < ActiveRecord::Migration
  def change
    create_table :stages_dogs do |t|

      t.timestamps
    end
  end
end
