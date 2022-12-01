class Price < ApplicationRecord
  belongs_to :store
  belongs_to :Product
end
