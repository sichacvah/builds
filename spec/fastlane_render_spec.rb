RSpec.describe CarmenBuilds::Builders::Android::FastlaneRender do
  let(:tmpdir) {CarmenBuilds::Builders::Builder.tmpdir}
  let(:template) {File.expand_path('../templates/fastlane', __FILE__)}
  let(:config) {create(:config)}
  let(:templates_path) {CarmenBuilds::Builders::Android::FastlaneRender::TEMPLATES_PATH}
  let(:git) {CarmenBuilds::Builders::Builder.clone_repo(config)}
  let(:fastlane) {
    config.git = git
    CarmenBuilds::Builders::Android::FastlaneRender.new config
  }

  describe '#save' do
    it 'render templates to project/fastlane/Appfile path' do
      fastlane.prepare
      path = file_path(File.join(template, 'Appfile.erb'), git)
      expect(File).to exist(path)
    end

    it 'render templates to project/fastlane/Fastfile path' do
      fastlane.prepare
      path = file_path(File.join(template, 'Fastfile.erb'), git)
      expect(File).to exist(path)
    end
  end
end
