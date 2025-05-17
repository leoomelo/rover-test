FactoryBot.define do
  factory :rover do
    pos_x { 1 }
    pos_y { 3 }
    direction { "N" }
    association :plateau
  end
end
