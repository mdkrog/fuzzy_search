class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :item_name
      t.float :lat
      t.float :lng
      t.text :item_url
      t.text :img_urls

      t.timestamps
    end
  end
end
