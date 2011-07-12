require 'spec_helper'

describe 'superd' do

  it 'successfully return a greeting' do
    get '/'
    last_response.should be_ok
    last_response.body.should include "Hello"
  end
end
