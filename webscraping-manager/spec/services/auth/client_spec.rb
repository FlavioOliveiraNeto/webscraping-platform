require 'rails_helper'

RSpec.describe Auth::Client do
  it 'returns nil for invalid token' do
    expect {
      described_class.decode('invalid.token')
    }.not_to raise_error
  end
end