class Item < ApplicationRecord  
  validates :item_name, presence: true
  attribute :distance, :float

  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :lat,
                   lng_column_name: :lng
  
  include PgSearch
  # fuzzy search that utilizes postgres fulltext capabilities
  pg_search_scope :item_name_search, against: [:item_name], using: {tsearch: {dictionary: "english", prefix: true, any_word: true}}  
  
  # niave fuzzy search - not utilising full text search
  def self.fuzzy_search(search_string)
    keywords_list = search_string.split(/[\s.,-]+/).map{ |item| "%" + item + "%" }
    where_clause = ""
    (1..keywords_list.length).each_with_index do |_, i| 
      where_clause += "item_name ILIKE ?"
      where_clause += " OR " if i < keywords_list.length - 1
    end
    where(where_clause, *keywords_list)
  end

  def self.nearby(origin:, radius: nil)
    if radius
      within(radius, origin: origin)
    else
      by_distance(origin: origin)
    end
  end

  def self.send_chain(methods)
    Array(methods).inject(self) { |o, a| o.send(*a) }
  end
end
