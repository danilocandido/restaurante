require 'rails_helper'

RSpec.describe Table, type: :model do
  subject { Table.find_or_create_by!(number: 11) }

  it { is_expected.to be_valid }
end
