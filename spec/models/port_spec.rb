require 'rails_helper'

RSpec.describe Port, type: :model do
  # Association test
  # ensure a port record belongs to a single port type record
  it { should belong_to(:port_type) }
  # Validation test
  # ensure column name is present before saving
  it { should validate_presence_of(:name) }
end
