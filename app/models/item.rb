class Item < ApplicationRecord
  validates :item_name, presence: true
end
