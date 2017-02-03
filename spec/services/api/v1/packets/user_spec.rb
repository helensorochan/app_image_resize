require 'rails_helper'

RSpec.describe Api::V1::Packets::Users do

  subject { described_class.new(params) }

  let(:allowed_version) { ALLOWED_VERSIONS.last }
  let!(:user){ create(:user, login: 'my_login', password: 'my_password') }

  describe '.login' do
    context 'when wrong user login' do
      let(:params){ { version: allowed_version,
                      login: 'test',
                      password: 'test',
                      device: '12345',
                      type: 'users',
                      action: 'login' } }
      it{ expect{subject.login[:error]}.to raise_error(I18n.t('request_errors.8')) }
    end

    context 'when wrong user password' do
      let(:params){ { version: allowed_version,
                      login: 'my_login',
                      password: 'test',
                      device: '12345',
                      type: 'users',
                      action: 'login' } }
      it{ expect{subject.login[:error]}.to raise_error(I18n.t('request_errors.9')) }
    end

    context 'without device info' do
      let(:params){ { version: allowed_version,
                      login: user.login,
                      password: user.password,
                      type: 'users',
                      action: 'login' } }
      it{ expect{subject.login[:error]}.to raise_error(I18n.t('request_errors.5')) }
    end

    context 'when correct data' do
      let(:params){ { version: allowed_version,
                      login: user.login,
                      password: user.password,
                      device: '6789',
                      type: 'users',
                      action: 'login' } }
      it 'then response' do
        result = subject.login
        session = Session.where(user_id: user.id, app_version: allowed_version, device: '6789').last
        expect(result[:session]).to eq(session.value)
      end
    end
  end

  describe '.logout' do
    let(:session){ create(:session, user: user) }
    let(:params){ { version: session.app_version,
                    device: session.device,
                    session: session.value,
                    type: 'users',
                    action: 'logout' } }

    context 'when session was checked' do
      before(:each){ subject.session = session }
      it { expect(subject.logout[:status]).to eq(true) }
      it { expect{subject.logout}.to change{Session.count}.by(-1) }
    end
  end
end
