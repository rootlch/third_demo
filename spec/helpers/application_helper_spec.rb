require 'spec_helper'

describe ApplicationHelper do

  describe 'full_title' do
    it 'should include the page title' do
      expect(full_title("foo")).to match(/foo/)
    end

    it 'should include the base title' do
      expect(full_title('foo')).to match(/\ARuby on Rails Tutorial Sample App/)
    end

    it 'should not include a bar for the home page' do
      expect(full_title('')).to_not match(/\|/)
    end
  end
end
