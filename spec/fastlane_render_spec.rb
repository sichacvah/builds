RSpec.describe CarmenBuilds::Builders::Android::FastlaneRender do
  let(:tmpdir) {CarmenBuilds::Builders::Builder.tmpdir}
  let(:config) {create(:config)}
  let(:templates_path) { CarmenBuilds::Builders::Android::FastlaneRender::TEMPLATES_PATH }
  let(:fastlane) {CarmenBuilds::Builders::Android::FastlaneRender.new config}

  describe '#save' do
    it 'render templates to project/fastlane path' do
      fastlane.prepare
      Dir.glob(templates_path +  '/*.erb') do |template|
        expect(File).to exists(fastlane.file_path(template))
      end
    end
  end
end
