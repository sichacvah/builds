RSpec.describe CarmenBuilds::Builders::Android::FastlaneRender do
  let(:tmpdir) {CarmenBuilds::Builders::Builder.tmpdir}
  let(:config) {create(:config)}
  let(:templates_path) { CarmenBuilds::Builders::Android::FastlaneRender::TEMPLATES_PATH }
  let(:fastlane) {CarmenBuilds::Builders::Android::FastlaneRender.new config}

  

  # context 'saving' do
  #
  #   let(:tmpdir) { CarmenBuilds::Builders::Builder.tmpdir }
  #   let(:config) do
  #     CarmenBuilds::Config.new do |config|
  #       config.repo_url = 'git@techinform.pro:carmen_client_app'
  #       config.project_name = 'carmen_client_app'
  #     end
  #   end
  #
  #   let(:fastlane) { CarmenBuilds::Builders::Android::FastlaneRender.new config }
  #
  #   let(:templates_path) { CarmenBuilds::Builders::Android::FastlaneRender::TEMPLATES_PATH }
  #
  #   describe '#save' do
  #     it 'render templates to project/fastlane path' do
  #       @fastlane.prepare
  #       @templates_path.each do |template|
  #         expect(File).to exists(@fastlane.file_path(template))
  #       end
  #     end
  #   end
  # end
end
