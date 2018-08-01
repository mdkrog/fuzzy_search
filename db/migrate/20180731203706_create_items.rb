class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :item_name, null: false, index: true
      t.float :lat, index: true
      t.float :lng, index: true
      t.text :item_url
      t.text :img_urls

      t.timestamps
    end
  end
end
