class RemoveSubIdFromPosts < ActiveRecord::Migration
  def change
    remove_index :posts, :sub_id
    remove_column :posts, :sub_id
  end
end
