class CreateJellies < ActiveRecord::Migration
  def self.up
    create_table :jellies do |t|
      t.string :title
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :jellies
  end
end
