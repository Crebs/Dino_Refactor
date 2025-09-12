require "simplecov"

SimpleCov.start do
  enable_coverage :branch
  add_filter "/spec/"  # don’t count spec files
end

require_relative "../lib/dino_manage"
require "rspec"

describe "Dino Management General Tests" do
  let(:dino_data) { [
    { "name"=>"DinoA", "category"=>"herbivore", "period"=>"Cretaceous", "diet"=>"plants", "age"=>100 },
    { "name"=>"DinoB", "category"=>"carnivore", "period"=>"Jurassic", "diet"=>"meat", "age"=>80 }
  ] }

  context "when using the long and unoptimized method" do
    describe "dino health calculation" do
      it "calculates dino health using age, category and diet" do
        result = DinoManagement.run(dino_data)[:dinos]
        a = result.find { |d| d["name"] == "DinoA" }
        b = result.find { |d| d["name"] == "DinoB" }

        expect(a["health"]).to eq(DinoManagement::MAX_HEALTH - 100)
        expect(b["health"]).to eq(DinoManagement::MAX_HEALTH - 80)
      end
    end

    describe "dino comment setting" do
      it "assigns appropriate comment based on health" do
        result = DinoManagement.run(dino_data)[:dinos]
        a = result.find { |d| d["name"] == "DinoA" }
        b = result.find { |d| d["name"] == "DinoB" }

        expect(a["comment"]).to eq(DinoManagement::STATUS_DEAD)
        expect(b["comment"]).to eq(DinoManagement::STATUS_ALIVE)
      end
    end

    describe "dino age metric calculation" do
      it "computes age_metrics based on age and comment" do
        result = DinoManagement.run(dino_data)[:dinos]
        a = result.find { |d| d["name"] == "DinoA" }
        b = result.find { |d| d["name"] == "DinoB" }

        expect(a["age_metrics"]).to eq(0)
        expect(b["age_metrics"]).to eq(40)
      end
    end

    describe "dino category summary" do
      it "counts dinos by categories" do
        result = DinoManagement.run(dino_data)[:summary]
        expect(result).to eq({ "herbivore" => 1, "carnivore" => 1 })
      end
    end

    describe "input validation & immutability" do
      it "raises on non-array input" do
        expect { DinoManagement.run(nil) }.to raise_error(ArgumentError)
        expect { DinoManagement.run("nope") }.to raise_error(ArgumentError)
      end
    
      it "does not mutate the original input" do
        original = [
          { "name"=>"X", "category"=>"herbivore", "period"=>"C", "diet"=>"plants", "age"=>5 }
        ]
        duped = Marshal.load(Marshal.dump(original))
        DinoManagement.run(original)
        expect(original).to eq(duped)
      end
    end
  end
end

describe "compute_health general tests" do
  it "returns 0 when age <= 0 (early return)" do
    data = [{ "name"=>"Zero", "category"=>"herbivore", "period"=>"x", "diet"=>"plants", "age"=>0 }]
    r = DinoManagement.run(data)[:dinos].first
    expect(r["health"]).to eq(0)
    expect(r["comment"]).to eq(DinoManagement::STATUS_DEAD)
  end

  it "uses base/2 when diet mismatches the default (else branch)" do
    # herbivore default is 'plants', feed it 'meat' to force mismatch
    data = [{ "name"=>"Mismatch", "category"=>"herbivore", "period"=>"x", "diet"=>"meat", "age"=>10 }]
    r = DinoManagement.run(data)[:dinos].first
    expect(r["health"]).to eq((DinoManagement::MAX_HEALTH - 10) / 2)
    expect(r["comment"]).to eq(DinoManagement::STATUS_ALIVE)
  end

  it "uses base/2 when category has no default (default is nil -> else branch)" do
    # 'omnivore' is not in DEFAULT_DIET, so default=nil
    data = [{ "name"=>"UnknownCat", "category"=>"omnivore", "period"=>"x", "diet"=>"plants", "age"=>10 }]
    r = DinoManagement.run(data)[:dinos].first
    expect(r["health"]).to eq((DinoManagement::MAX_HEALTH - 10) / 2)
  end
end