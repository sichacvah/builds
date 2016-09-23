RSpec.describe CarmenBuilds::Builders::Android::AndroidBuilder do

  context '#prepare_icons' do
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

  context '#set_store_name' do
    let(:config) { create(:config) }
    let(:android_builder) {CarmenBuilds::Builders::Android::AndroidBuilder}
    let(:git) {CarmenBuilds::Builders::Builder.clone_repo(config)}
    let(:res_path) {CarmenBuilds::Builders::Android::AndroidBuilder::RES_PATH}

    it 'set rus name in android strings.xml' do
      config.git = git
      android_builder.set_store_name(config)
      path = File.join(config.git.dir.path, res_path, 'values', 'strings.xml')
      file = File.read(path)
      expect(file).to include("<string name=\"rus_name\">#{config.store_name}</string>")
    end
  end
end
