class ItemSearch
  attr_reader :search_term, :lat, :lng, :radius, :limit
  attr_writer :relevance_evaluator

  def initialize(search_term: nil, lat: nil, lng: nil, radius: nil, limit: 20)
    @search_term = search_term
    @lat = lat
    @lng = lng
    @radius = radius
    @limit = limit
  end

  def call
    begin
      results = run_query(build_query)
      sort_and_truncate(results)
    rescue StandardError => e
      { error: e.message }
    end
  end

  private

  def build_query
    scopes = []
    scopes << [:fuzzy_search, search_term] if search_term
    scopes << [:nearby, origin: origin, radius: radius] if origin    
    scopes << [:limit, 100] if scopes.any? # get a large set to later sort and truncate down to limit
    scopes
  end

  def run_query(query)
    raise StandardError.new("No queriable fields provided") if query.empty?
    Item.send_chain(query)
  end

  def sort_and_truncate(results)
    result.sort_by{ |item| relevance_evaluator.score(item) }.slice(0, limit)
  end

  def origin
    lat && lng ? [lat,lng] : nil
  end

  def relevance_evaluator
    @relevance_evaluator ||= RelevanceEvaluator.new(search_term, origin)
  end
end