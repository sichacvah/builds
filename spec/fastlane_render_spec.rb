
RSpec.describe CarmenBuilds::Builders::FastlaneRender do
  let(:tmpdir) {CarmenBuilds::Builders::Builder.tmpdir}
  let(:template) {File.expand_path('../templates/fastlane', __FILE__)}
  let(:config) {create(:config)}
  let(:templates_path) {CarmenBuilds::Builders::FastlaneRender::TEMPLATES_PATH}
  let(:git) {CarmenBuilds::Builders::Builder.clone_repo(config)}
  let(:fastlane) {
    config.git = git
    CarmenBuilds::Builders::FastlaneRender.new config
  }
  let(:dest_android) { 'android/fastlane' }
  let(:templates_android) {File.expand_path('templates/fastlane/android')}
  let(:appfile_android) {file_path(File.join(template, 'Appfile.erb'), git, dest_android)}
  let(:fastfile_android) {file_path(File.join(template, 'Fastfile.erb'), git, dest_android)}

  let(:dest_ios) { 'ios/fastlane' }
  let(:templates_ios) {File.expand_path('templates/fastlane/ios')}
  let(:appfile_ios) {file_path(File.join(template, 'Appfile.erb'), git, dest_ios)}
  let(:fastfile_ios) {file_path(File.join(template, 'Fastfile.erb'), git, dest_ios)}
  let(:deliverfile_ios) {file_path(File.join(template, 'Deliverfile.erb'), git, dest_ios)}

  describe '#save' do
    context 'render android templates' do
      before(:each) do
        fastlane.prepare({
          templates: File.expand_path('templates/fastlane/android'),
          destinition: 'android/fastlane'
        })
      end

      it 'render templates to project/android/fastlane/Appfile path' do
        expect(File).to exist(appfile_android)
      end

      it 'render templates to project/android/fastlane/Fastfile path' do
        expect(File).to exist(fastfile_android)
      end
    end

    context 'render ios tempaltes' do
      before(:each) do
        fastlane.prepare({
          templates: File.expand_path('templates/fastlane/ios'),
          destinition: 'ios/fastlane'
        })
      end

      it 'render templates to project/ios/fastlane/Fastfile path' do
        expect(File).to exist(fastfile_ios)
      end

      it 'render templates to project/ios/fastlane/Appfile path' do
        expect(File).to exist(appfile_ios)
      end

      it 'render templates to project/ios/fastlane/Deliverfile path' do
        expect(File).to exist(deliverfile_ios)
      end
    end

  end
end
