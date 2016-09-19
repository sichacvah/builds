RSpec.describe CarmenBuilds::Builders::Android::AndroidBuilder do
  describe '#prepare_icons' do
    it 'fetch icons and resize it' do
      begin
        tmpdir = FileUtils.mkdir_p(File.join(CarmenBuilds::Builders::Builder.tmp_path))
        config = CarmenBuilds::Config.new do |config|
          config.git = Git.init(File.join(tmpdir, 'carmen_app_test'))
          config.project_name = 'carmen_app_test'
          config.icon_url = 'http://www.car4men.ru/images/app_logo_big.png'
        end
        android_builder = CarmenBuilds::Builders::Android::AndroidBuilder.new
        res_path = CarmenBuilds::Builders::Android::AndroidBuilder::RES_PATH
        icons = CarmenBuilds::Builders::Android::AndroidBuilder::ICON_SIZES
        FileUtils.mkdir_p(File.join(config.git.dir.path, res_path))

        android_builder.prepare_icons(config)
        icons.each do |key, value|
          path = File.join(config.git.dir.path, res_path, "drawable-#{key}", 'ic_launcher.png')
          expect(File).to exist(path)
        end
      ensure
        path = File.join(CarmenBuilds::Builders::Builder.tmp_path, 'carmen_app_test')
        FileUtils.rm_rf( path ) if File.exists?( path )
      end
    end
  end
end
