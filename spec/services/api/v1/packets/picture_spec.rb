require 'rails_helper'

RSpec.describe Api::V1::Packets::Pictures do

  subject { described_class.new(params) }
  let(:user){ create(:user) }
  let(:session){ create :session, user: user }
  let!(:image1){ create(:picture, file_name: '1.png', user: user.id, width: 789, height: 100) }
  let!(:image2){ create(:picture, file_name: '2.png', user: user.id, width: 500, height: 100) }

  before(:each){ subject.user = session.user }

  describe '.collection' do
    context 'when user has a few pictures' do
      let(:params){ { type: 'pictures',
                      action: 'collection',
                      session: session.value,
                      version: '1',
                      device: session.device } }
      it  do
        expected_result = [
          { picture: { path: image1.file_path, width: 789, height: 100, name: image1.file_name }, status: true },
          { picture: { path: image2.file_path, width: 500, height: 100, name: image2.file_name}, status: true }
        ]
        expect(subject.collection).to match_array(expected_result)
      end
    end

    context 'when user has not picture' do
      let(:session){ create :session }
      let(:params){ { type: 'pictures',
                      action: 'collection',
                      session: session.value,
                      version: '1',
                      device: session.device } }
      it { expect(subject.collection).to be_empty }
    end
  end

  describe '.upload' do
    before(:each) do
      FileUtils.mkdir_p(Rails.root.join('tmp', 'pictures'))
    end

    after(:each) do
      FileUtils.rm_r(Rails.root.join('tmp', 'pictures'))
    end


    context 'when content type is blank' do
      let(:params) { { type: 'pictures',
                       action: 'upload',
                       session: session.value,
                       version: '1',
                       origin_file_name: '1.png',
                       file: '@1.png',
                       width: '100',
                       height: '100' } }
      it { expect{subject.upload}.to raise_error(I18n.t('request_errors.10')) }
    end

    context 'when content type is not allowed' do
      let(:params) { { type: 'pictures',
                       action: 'upload',
                       session: session.value,
                       version: '1',
                       origin_file_name: '1.png',
                       content_type: 'image/gif',
                       file: '@1.png',
                       width: '100',
                       height: '100' } }
      it { expect{subject.upload}.to raise_error(I18n.t('request_errors.10')) }
    end

    context 'when origin file name is blank' do
      let(:params) { { type: 'pictures',
                       action: 'upload',
                       session: session.value,
                       version: '1',
                       content_type: 'image/png',
                       file: '@1.png',
                       width: '100',
                       height: '100' } }
      it { expect{subject.upload}.to raise_error(I18n.t('request_errors.11')) }
    end

    context 'when file is blank' do
      let(:params) { { type: 'pictures',
                       action: 'upload',
                       session: session.value,
                       version: '1',
                       content_type: 'image/png',
                       origin_file_name: '1.png',
                       width: '100',
                       height: '100' } }
      it { expect{subject.upload}.to raise_error(I18n.t('request_errors.12')) }
    end

    context 'when width is blank' do
      let(:params) { { type: 'pictures',
                       action: 'upload',
                       session: session.value,
                       version: '1',
                       content_type: 'image/png',
                       origin_file_name: '1.png',
                       file: '@1.png',
                       height: '100' } }
      it { expect{subject.upload}.to raise_error(I18n.t('request_errors.13')) }
    end

    context 'when height is blank' do
      let(:params) { { type: 'pictures',
                       action: 'upload',
                       session: session.value,
                       version: '1',
                       content_type: 'image/png',
                       origin_file_name: '1.png',
                       file: '@1.png',
                       width: '100' } }
      it { expect{subject.upload}.to raise_error(I18n.t('request_errors.13')) }
    end

    context 'when upload data is correct' do
      let(:params) { { type: 'pictures',
                       action: 'upload',
                       session: session.value,
                       version: '1',
                       content_type: 'image/png',
                       origin_file_name: '1.png',
                       file: 'spec/fixtures/1.png',
                       height: '100',
                       width: '100' } }
      let(:file_path) { Rails.root.join('tmp', 'pictures', 'test.png') }

      it 'and image was attached' do
        allow_any_instance_of(Picture).to receive(:file_name).and_return('test.png')
        allow_any_instance_of(Picture).to receive(:file_path).and_return(file_path)
        actual_result = subject.upload

        expect(actual_result[:status]).to be true
        expect(actual_result[:picture]).to eq(path: file_path, width: 100, height: 100, name: 'test.png')
        expect(MiniMagick::Image.open(Rails.root.join('tmp', 'pictures', 'test.png')).width).to eq(100)
      end
    end
  end

  describe '.resize' do
    before(:each) do
      FileUtils.mkdir_p(Rails.root.join('tmp', 'pictures'))
    end

    after(:each) do
      FileUtils.rm_r(Rails.root.join('tmp', 'pictures'))
    end

    let!(:picture){ create :picture,
                          file_name: 'test.png',
                          width: '500',
                          height: '500',
                          content_type: 'image/png',
                          user_id: session.user_id
                 }
    let(:file_path) { Rails.root.join('tmp', 'pictures', 'test.png') }

    context 'when file_name is blank' do
      let(:params){ { type: 'pictures',
                      action: 'resize',
                      session: session,
                      width: picture.width,
                      height: picture.height } }
      it { expect{subject.resize}.to raise_error(I18n.t('request_errors.11')) }
    end

    context 'when width is blank' do
      let(:params){ { type: 'pictures',
                      action: 'resize',
                      session: session,
                      file_name: picture.file_name,
                      height: picture.height } }
      it { expect{subject.resize}.to raise_error(I18n.t('request_errors.13')) }
    end

    context 'when picture not found' do
      let(:params){ { type: 'pictures',
                      action: 'resize',
                      session: session,
                      file_name: 'test.png',
                      width: '200',
                      height: '200'} }
      it { expect{subject.resize}.to raise_error(I18n.t('request_errors.15')) }
    end

    context 'when correct parameters' do
      let(:params){ { type: 'pictures',
                      action: 'resize',
                      session: session,
                      file_name: picture.file_name,
                      width: picture.width,
                      height: picture.height } }
      let(:file_path){ Rails.root.join('tmp', 'pictures', picture.file_name) }

      it do
        binary_data = File.binread('spec/fixtures/1.png')
        allow_any_instance_of(Picture).to receive(:file_path).and_return(file_path)
        File.open(file_path, 'wb'){|file| file.write(binary_data) }
        expect(subject.resize[:status]).to be true
      end
    end
  end
end
