require_relative "../lib/dino"

RSpec.describe Dino do
  let(:d) { Dino.new("A", "herbivore", "Cretaceous", "plants", 10) }

  it "computes health as base when diet matches" do
    expect(d.health).to eq(90)
    expect(d.comment).to eq("Alive")
    expect(d.age_metrics).to eq(5)
  end

  it "halves health when diet mismatches or category unknown" do
    m = d.with(diet: "meat")
    expect(m.health).to eq(45)
    expect(m.comment).to eq("Alive")
    expect(m.age_metrics).to eq(5/1) # still 5 since age 10 -> 10/2
  end

  it "returns 0 health for non-positive age" do
    baby = d.with(age: 0)
    expect(baby.health).to eq(0)
    expect(baby.comment).to eq("Dead")
    expect(baby.age_metrics).to eq(0)
  end
end