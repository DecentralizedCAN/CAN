class AddLinksToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :link, foreign_key: true
    add_reference :links, :post, foreign_key: true
  end
end
