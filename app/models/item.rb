class Item < ApplicationRecord
  validates :item_name, presence: true

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :lat,
                   lng_column_name: :lng
  
  def self.send_chain(methods)
    Array(methods).inject(self) { |o, a| o.send(*a) }
  end
  
  def self.fuzzy_search(search_string)
    keywords_list = search_string.split(/[\s.,-]+/).map{ |item| "%" + item + "%" }
    where_clause = ""
    (1..keywords_list.length).each_with_index do |_, i| 
      where_clause += "item_name LIKE ?"
      where_clause += " OR " if i < keywords_list.length - 1
    end

    where(where_clause, *keywords_list)
  end

  def self.nearby(origin:, radius: nil)
    if radius
      within(radius*2, origin: origin)
    else
      by_distance(origin: origin)
    end
  end
end
