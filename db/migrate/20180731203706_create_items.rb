class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :item_name, null: false, index: true
      t.float :lat
      t.float :lng
      t.text :item_url
      t.text :img_urls
    end
  end
end
