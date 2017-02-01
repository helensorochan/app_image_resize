require 'rails_helper'

RSpec.describe Api::V1::Packets::Base do

  subject { described_class.new(params) }

  let(:allowed_version) { ALLOWED_VERSIONS.last }
  let!(:user){ User.create(login: 'my_login', password: Digest::SHA1.hexdigest('my_password')) }
  let!(:session){ Session.create(user: user, device: '12345', app_version: allowed_version, value: '22222') }


  describe '.authenticate_user!' do
    context 'when action requires session and session not found' do
      let(:params){ {version: allowed_version,
                     device: '1234',
                     type: 'users',
                     version: allowed_version,
                     action: 'logout'} }
      it{ expect{subject.authenticate_user!}.to raise_error(I18n.t('request_errors.3')) }
    end

    context 'when action requires session and data found' do
      let(:params){ {version: allowed_version,
                     device: '12345',
                     type: 'users',
                     session: session.value,
                     action: 'logout'} }
      before(:each) { subject.authenticate_user! }
      it{ expect(subject.user.id).to eq(user.id) }
      it{ expect(subject.session.value).to eq(session.value) }
    end
  end
end
