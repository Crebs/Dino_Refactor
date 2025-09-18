# frozen_string_literal: true

class Normalizer
  def initialize(strict: false, defaults: {})
    @strict   = strict
    @defaults = defaults
  end

  def call(row)
    out = {
      name:     get(row, :name)     || @defaults[:name],
      category: get(row, :category) || @defaults[:category],
      period:   get(row, :period)   || @defaults[:period],
      diet:     get(row, :diet)     || @defaults[:diet],
      age:      Integer(get(row, :age), exception: false) || 0
    }
    validate!(out) if @strict
    out.freeze
  end

  private

  def get(h, key)
    h[key] || h[key.to_s]
  end

  def validate!(h)
    %i[name category diet].each do |k|
      raise ArgumentError, "Missing required field: #{k}" if h[k].nil? || (h[k].respond_to?(:empty?) && h[k].empty?)
    end
  end
end