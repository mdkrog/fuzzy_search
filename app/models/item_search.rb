class ItemSearch
  attr_reader :search_term, :lat, :lng, :radius, :limit
  attr_accessor :relevance_evaluator

  def initialize(search_term: nil, lat: nil, lng: nil, radius: nil, limit: 20)
    @search_term = search_term
    @lat = lat
    @lng = lng
    @radius = radius
    @limit = Integer limit rescue 20 # if malformed limit default to 20
  end

  def call
    begin
      results = run_query(build_query)
      sort_and_truncate(results)
    rescue EmptyQueryError => e
      { error: e.message }
    end
  end

  def relevance_evaluator
    @relevance_evaluator ||= RelevanceEvaluator.new(search_term, origin)
  end

  private

  def build_query
    scopes = []
    scopes << [:fuzzy_search, search_term] if search_term
    scopes << [:nearby, origin: origin, radius: radius] if origin    
    scopes << [:limit, 100] if scopes.any? # get a large set to later sort and truncate down to limit in ruby
    scopes
  end

  def run_query(query)
    raise EmptyQueryError.new("No queriable fields provided") if query.empty?
    Item.send_chain(query)
  end

  def sort_and_truncate(results)
    results.sort_by{ |item| relevance_evaluator.score(item) }.reverse.slice(0, limit).map{ |item| [relevance_evaluator.score(item), item.distance_to(origin, units: :kms), item.item_name] }
  end

  def origin
    origin_malformed? ? nil : [lat,lng]
  end

  def origin_malformed?
    !((Float lat rescue false) && (Float lng rescue false))
  end
end