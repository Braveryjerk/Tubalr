class RemoveSupporterFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :supporter
  end
end
