require_relative "dino"
require_relative "normalizer"

module DinoManagement
  STATUS_ALIVE = "Alive"
  STATUS_DEAD  = "Dead"
  MAX_HEALTH   = 100

  module_function

  def run(rows, normalizer: Normalizer.new)
    raise ArgumentError, "rows must be an Array" unless rows.is_a?(Array)

    dinos = rows.map { |row| to_dino(normalizer.call(row)) }

    enriched = dinos.map { |dino| enrich_dino(dino) }
    { dinos: enriched, summary: summarize_by_category(enriched) }
  end

  def to_dino(normalized)
    Dino.new(
      normalized[:name],
      normalized[:category],
      normalized[:period],
      normalized[:diet],
      normalized[:age]
    )
  end

  def enrich_dino(dino)
    health = compute_health(dino)
    comment = health.positive? ? STATUS_ALIVE : STATUS_DEAD
    age_metrics = (comment == STATUS_ALIVE && dino.age > 1) ? (dino.age / 2) : 0

    dino.to_h
      .transform_keys(&:to_s)
      .merge(
        "health"      => health,
        "comment"     => comment,
        "age_metrics" => age_metrics
      )
  end

  def compute_health(dino)
    return 0 unless dino.age.positive?
    base = MAX_HEALTH - dino.age
    default = { "herbivore" => "plants", "carnivore" => "meat" }[dino.category]
    default == dino.diet ? base : base / 2
  end

  def summarize_by_category(enriched)
    enriched.group_by { |row| row["category"] }.transform_values(&:count)
  end
end