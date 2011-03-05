class CreatePeanutButters < ActiveRecord::Migration
  def self.up
    create_table :peanut_butters do |t|
      t.string :viscosity
      t.timestamps
    end
  end

  def self.down
    drop_table :peanut_butters
  end
end
