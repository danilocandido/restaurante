class Table < ApplicationRecord
  validates :number, uniqueness: true
end
