
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
  let(:appfile) {file_path(File.join(template, 'Appfile.erb'), git, dest_android)}
  let(:fastfile_android) {file_path(File.join(template, 'Fastfile.erb'), git, dest_android)}


  describe '#save' do
    it 'render templates to project/android/fastlane/Appfile path' do
      fastlane.prepare({
        templates: templates_android,
        destinition: dest_android
      })
      expect(File).to exist(appfile)
    end

    it 'render templates to project/android/fastlane/Fastfile path' do
      fastlane.prepare({
        templates: templates_android,
        destinition: dest_android
      })
      expect(File).to exist(fastfile_android)
    end
  end
end
