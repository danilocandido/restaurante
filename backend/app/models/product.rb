class Product < ApplicationRecord
  enum category: %i[prato bebida]
end
