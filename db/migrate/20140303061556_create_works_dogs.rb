class CreateWorksDogs < ActiveRecord::Migration
  def change
    create_table :works_dogs do |t|

      t.timestamps
    end
  end
end
