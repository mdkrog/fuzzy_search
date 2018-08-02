class RelevanceEvaluator
  attr_accessor :search_term, :origin, :term_similarity_weighting, :closeness_weighting

  def initialize(search_term, origin, term_similarity_weighting=5, closeness_weighting=5)
    @search_term = search_term
    @origin = origin
    @term_similarity_weighting = term_similarity_weighting
    @closeness_weighting = closeness_weighting
  end

  def score(item)
    (term_similarity_rating(item.item_name) * term_similarity_weighting) + (closeness_rating(item) * closeness_weighting)
  end

  private

  def term_similarity_rating(item_name)
    String::Similarity.cosine(item_name, search_term)
  end

  def distance_to(item)
    item.distance_to(origin)
  end

  def closeness_rating(item)
    case distance_to(item).to_i
    when 0..1 # within 2km
      1
    when 2..4 # within 5km
      0.8
    when 4..9 # within 10km
      0.6
    when 11..20 # within 20km
      0.3
    else
      0
    end
  end
end