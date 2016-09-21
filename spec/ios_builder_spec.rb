RSpec.describe CarmenBuilds::Builders::IOS::IOSBuilder do

  let(:config) { create(:config) }
  let(:ios_builder) {CarmenBuilds::Builders::IOS::IOSBuilder }
  let(:git) {CarmenBuilds::Builders::Builder.clone_repo(config)}
  let(:icons_res_path) {ios_builder.icons_res_path config}
  let(:screens_res_path) {ios_builder.screens_res_path config}
  let(:icons) {CarmenBuilds::Builders::IOS::IOSBuilder::ICON_SIZES}
  let(:screens) {CarmenBuilds::Builders::IOS::IOSBuilder::SCREEN_SIZES}

  describe '#prepare_icons' do
    it 'fetch icons and resize it' do
      config.git = git
      ios_builder.prepare_icons(config)
      icons.each do |key, value|
        path = File.join(icons_res_path, key.to_s + '.png')
        expect(File).to exist(path)
      end
    end

    it 'create contents.json' do
      config.git = git
      ios_builder.prepare_icons(config)
      contents = File.read(File.join(icons_res_path, 'Contents.json'))
      originalContents = File.read('spec/IconContents.json')
      expect(contents).to eq(originalContents)
    end
  end


  describe '#screens_res_path' do
    it 'create folder for screens' do
      config.git = git
      expect(File.directory?(screens_res_path)).to be true
    end
  end

  describe '#icons_res_path' do
    it 'create folder for icons' do
      config.git = git
      expect(File.directory?(icons_res_path)).to be true
    end
  end


  describe '#prepare_screens' do
    it 'fetch icons and create splash screens' do
      config.git = git
      ios_builder.prepare_screens(config)
      screens.each do |key, value|
        path = File.join(screens_res_path, key.to_s + '.png')
        expect(File).to exist(path)
      end
    end

    it 'create contents.json' do
      config.git = git
      ios_builder.prepare_screens(config)
      contents = File.read(File.join(screens_res_path, 'Contents.json'))
      originalContents = File.read('spec/ScreenContents.json')
      expect(JSON.parse contents).to eq(JSON.parse originalContents)
    end
  end
end
