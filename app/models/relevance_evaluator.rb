class RelevanceEvaluator
  attr_accessor :search_term, :origin, :term_similarity_weighting, :closeness_weighting

  def initialize(search_term, origin, term_similarity_weighting=5, closeness_weighting=5)
    @search_term = search_term
    @origin = origin
    @term_similarity_weighting = term_similarity_weighting
    @closeness_weighting = closeness_weighting
  end

  def score(item)
    score = 0
    score += term_similarity_rating(item.item_name) * term_similarity_weighting if search_term
    score += closeness_rating(item) * closeness_weighting if origin
    score
  end

  private

  def term_similarity_rating(item_name)
    String::Similarity.cosine(item_name, search_term)
  end

  def distance_to(item)
    item.distance_to(origin, units: :kms)
  end

  def closeness_rating(item)
    dist = distance_to(item)
    score = case
    when dist < 2 # within 2km
      1
    when dist < 5 # within 5km
      0.8
    when dist < 10 # within 10km
      0.6
    when dist < 20 # within 20km
      0.3
    else
      0
    end
    score += 1/dist
  end
end