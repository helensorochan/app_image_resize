require 'rails_helper'

RSpec.describe Api::RequestProcessor do

  subject{ described_class.new(params).perform }
  let(:allowed_version) { ALLOWED_VERSIONS.last }

  describe '.perform' do
    context 'when wrong app version' do
      let(:params){ {version: '0001'} }
      it{ expect(subject[:error]).to eq(I18n.t('request_errors.1')) }
    end

    context 'when blank app version' do
      let(:params){ { } }
      it{ expect(subject[:error]).to eq(I18n.t('request_errors.1')) }
    end

    context 'when wrong packet type', y: true do
      let(:params){ {type: 'user', version: allowed_version} }
      it{ expect(subject[:error]).to eq(I18n.t('request_errors.2')) }
    end

    context 'when blank packet type' do
      let(:params){ {version: allowed_version} }
      it{ expect(subject[:error]).to eq(I18n.t('request_errors.2')) }
    end

    context 'when wrong packet action' do
      let(:params){ {type: 'users', action: 'destroy', version: allowed_version} }
      it{ expect(subject[:error]).to eq(I18n.t('request_errors.7')) }
    end

    context 'when blank packet action' do
      let(:params){ {type: 'users', version: allowed_version} }
      it{ expect(subject[:error]).to eq(I18n.t('request_errors.7')) }
    end

    context 'when login with correct params' do
      let(:user){ create(:user, login: 'my_login', password: 'my_password') }

      let(:params){ {login: user.login,
                    password: user.password,
                    version: allowed_version,
                    device: '12345',
                    type: 'users',
                    action: 'login'} }

      it 'then response' do
        result = subject
        session = Session.where(user_id: user.id, app_version: allowed_version, device: '12345').last
        expect(result[:session]).to eq(session.value)
      end
    end
  end
end
