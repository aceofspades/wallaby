require 'rails_helper'

partial_name = 'show/cidr'
describe partial_name do
  let(:partial)   { "wallaby/resources/#{partial_name}.html.erb" }
  let(:value)     { IPAddr.new '192.168.2.0/24' }
  let(:metadata)  { {} }

  before { render partial, value: value, metadata: metadata }

  it 'renders the cidr' do
    expect(rendered).to include "<code>#{value}</code>"
    expect(rendered).to include "http://ip-api.com/##{value}"
  end

  context 'when value is nil' do
    let(:value) { nil }
    it 'renders null' do
      expect(rendered).to include view.null
    end
  end
end
