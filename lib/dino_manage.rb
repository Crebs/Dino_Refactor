# frozen_string_literal: true

# DinoManagement: pure, testable business logic for "dino" records.
# Input:  Array<Hash> with keys: "name", "category", "period", "diet", "age"
# Output: { dinos: Array<Hash(with computed fields)>, summary: Hash[String,Integer] }
#
# Behavior preserved from the legacy script:
# - health:
#   - if age <= 0 => 0
#   - else base = 100 - age
#     - if diet == default diet for category => health = base
#     - else health = base / 2 (integer division)
# - comment: "Alive" if health > 0, otherwise "Dead"
# - age_metrics: if comment == "Alive" and age > 1 => (age / 2).to_i, else 0
# - summary: counts by category (string keys)
#
module DinoManagement
  DEFAULT_DIET = {
    'herbivore' => 'plants',
    'carnivore' => 'meat'
  }.freeze
  MAX_HEALTH = 100
  STATUS_ALIVE = 'Alive'
  STATUS_DEAD = 'Dead'

  module_function

  def run(dinos)
    raise ArgumentError, 'dinos must be an Array' unless dinos.is_a?(Array)

    enriched = dinos.map { |d| enrich_dino(d.dup) }
    { dinos: enriched, summary: summarize_by_category(enriched) }
  end

  # --- helpers ---

  def enrich_dino(dino)
    age       = Integer(dino['age'], exception: false) || 0
    category  = dino['category']
    diet      = dino['diet']

    health = compute_health(age: age, category: category, diet: diet)
    comment = health.positive? ? STATUS_ALIVE : STATUS_DEAD
    age_metrics = (comment == STATUS_ALIVE && age > 1) ? (age / 2).to_i : 0

    dino.merge('health' => health, 'comment' => comment, 'age_metrics' => age_metrics)
  end

  def compute_health(age:, category:, diet:)
    return 0 unless age.positive?

    base = MAX_HEALTH - age
    default = DEFAULT_DIET[category]
    if !default.nil? && diet == default
      base
    else
      base / 2
    end
  end

  def summarize_by_category(dinos)
    dinos
      .group_by { |d| d['category'] }
      .transform_values(&:count)
  end
end