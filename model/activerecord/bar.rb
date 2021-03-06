class Bar < ActiveRecord::Base
  validates :name, length: { maximum: 100 }, presence: true, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :ingredients
  before_destroy {|bar| bar.ingredients.clear}

  default_scope { includes(:ingredients) }

  def ingredient_names
    return ingredients.collect { |i| i.name }
  end
  
  def add(ingredient_name)
    ingredients << Ingredient.where(name: ingredient_name)
  end
  
  def remove(ingredient_name)
    ingredients.delete(Ingredient.where(name: ingredient_name))
  end
  
  def include?(ingredient_name)
    ingredients.any? { |i| i.name == ingredient_name }
  end
  
  def can_do?(cocktail)
    # TODO: To optimize.
    (cocktail.ingredient_names - ingredient_names).empty?
  end
  
  def stats
    return @stats
  end
  
  def compute_stats(all_cocktails)
    @stats = BarStatsCalculator.new.compute_stats(self, all_cocktails)
    return stats
  end
  
  def clone
    clone = Bar.new
    clone.name = name
    clone.ingredients = ingredients
    return clone
  end

end