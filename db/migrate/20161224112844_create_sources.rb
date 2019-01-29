class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :url
      t.boolean :official, :index => true, :default => true
      t.string :main_type, :index => true, :default => 'gafuk'

      t.timestamps
    end
  end
end
