# frozen_string_literal: true

Dino = Data.define(:name, :category, :period, :diet, :age) do
  DEFAULT_DIET = { 'herbivore' => 'plants', 'carnivore' => 'meat' }.freeze
  MAX_HEALTH   = 100
  AGE_DIVISOR  = 2

  # Compute health based only on Dino’s own data.
  def health(max_health: MAX_HEALTH, default_diet: DEFAULT_DIET)
    return 0 unless age.positive?

    base     = max_health - age
    expected = default_diet[category]
    expected == diet ? base : base / 2
  end

  def comment(max_health: MAX_HEALTH, default_diet: DEFAULT_DIET)
    health(max_health:, default_diet:) > 0 ? 'Alive' : 'Dead'
  end

  def age_metrics(max_health: MAX_HEALTH, default_diet: DEFAULT_DIET, divisor: AGE_DIVISOR)
    h = health(max_health:, default_diet:)
    (h.positive? && age > 1) ? (age / divisor).to_i : 0
  end

  # Handy helper for merging computed fields
  def to_h_string_keys
    to_h.transform_keys!(&:to_s)
  end
end