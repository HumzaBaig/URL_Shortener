class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :visitor_id, null: false, index: true
      t.integer :url_id, null: false, index: true
      t.timestamps
    end
  end
end
