class CreateCalculateScores < ActiveRecord::Migration
  def change
    create_table :calculate_scores do |t|

      t.timestamps
    end
  end
end
