class Quote < ApplicationRecord
  validates :symbol, presence: true,
                    uniqueness: true

  validates :name, presence: true
  validates :exchange, presence: true


end
