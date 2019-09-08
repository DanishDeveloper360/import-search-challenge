require 'rails_helper'

# Test suite for the PortType model
RSpec.describe PortType, type: :model do
  # Association test
  # ensure PortType model has a 1:m relationship with the Item model
  it { should have_many(:ports).dependent(:destroy) }
end