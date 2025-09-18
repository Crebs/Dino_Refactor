# frozen_string_literal: true
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
    dino.to_h_string_keys.merge(
      "health"      => dino.health,
      "comment"     => dino.comment,
      "age_metrics" => dino.age_metrics
    )
  end

  def summarize_by_category(enriched)
    enriched.group_by { |row| row["category"] }.transform_values(&:count)
  end
end