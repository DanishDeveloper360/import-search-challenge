class Port < ApplicationRecord
  # model association
  belongs_to :port_type, optional: true

  # validations
  validates_presence_of :name, :code
end
