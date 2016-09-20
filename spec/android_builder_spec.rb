RSpec.describe CarmenBuilds::Builders::Android::AndroidBuilder do
  describe '#prepare_icons' do

    let(:config) { create(:icon_config) }
    let(:android_builder) {CarmenBuilds::Builders::Android::AndroidBuilder }
    let(:res_path) {CarmenBuilds::Builders::Android::AndroidBuilder::RES_PATH}
    let(:icons) {CarmenBuilds::Builders::Android::AndroidBuilder::ICON_SIZES}
    let(:workdir) {FileUtils.mkdir_p(File.join(config.git.dir.path, res_path))}

    it 'fetch icons and resize it' do
        android_builder.prepare_icons(config)
        icons.each do |key, value|
          path = File.join(config.git.dir.path, res_path, "drawable-#{key}", 'ic_launcher.png')
          expect(File).to exist(path)
        end
    end
  end
end
