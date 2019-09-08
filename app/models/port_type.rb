class PortType < ApplicationRecord
  # model association
  has_many :ports, dependent: :destroy
end
