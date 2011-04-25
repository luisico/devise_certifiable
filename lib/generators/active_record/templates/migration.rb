class DeviseCertifiableAddTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table :<%= table_name %> do |t|
      t.string     :certification_token, :limit => 60
      t.datetime   :certified_at
      t.references :certified_by, :polymorphic => true
      t.index      :certification_token
      t.index      :certified_by_id
    end
  end
  
  def self.down
    change_table :<%= table_name %> do |t|
      t.remove_references :certified_by, :polymorphic => true
      t.remove :certification_token, :certified_at
    end
  end
end
