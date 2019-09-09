class Port < ApplicationRecord
  # model association
  belongs_to :port_type, optional: true

  # validations
  validates_presence_of :name, :code

  def self.WithPortType
    Port.joins(:port_type).select("ports.*, port_types.name as port_type_name")
  end
  

end
