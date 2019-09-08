class Port < ApplicationRecord
  # model association
  belongs_to :port_type

  # validations
  validates_presence_of :name, :code
end
