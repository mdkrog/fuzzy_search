class Item < ApplicationRecord
  validates :item_name, presence: true

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :lat,
                   lng_column_name: :lng
  

  # def similarity(search_term)
  #   String::Similarity.cosine(self.item_name, search_term)
  # end

  # def distance_score(search_term)
  #   String::Similarity.cosine(self.item_name, search_term)
  # end

  # def score(origin, search_term)
  #   # self.where(score: 10)
  # end
  
  def self.fuzzy_search(search_string)
    keywords_list = search_string.split(/[\s.,-]+/).map{ |item| "%" + item + "%" }
    where_clause = ""
    (1..keywords_list.length).each_with_index do |_, i| 
      where_clause += "item_name LIKE ?"
      where_clause += " OR " if i < keywords_list.length - 1
    end

    where(where_clause, *keywords_list).limit(2)
  end

  def self.nearby(origin:, radius: nil)
    if radius
      self.within(radius*2, origin: origin)
    else
      self.by_distance(origin: origin)   
    end
  end
end
