RSpec.describe CarmenBuilds::Builders::Builder do

  context 'work in tmp dir' do
    describe '#tmdir' do
      let(:builder) {CarmenBuilds::Builders::Builder}
      let(:tmpdir) {builder.tmpdir}
      let(:config) {create(:config)}
      it "create tmp dir" do
        expect(File).to exist(File.join(tmpdir))
      end
    end

    describe '#clone_repo' do
      let(:builder) {CarmenBuilds::Builders::Builder}
      let(:tmpdir) {builder.tmpdir}
      let(:config) {create(:config)}
      it 'will clone repository to tmp directory' do
        builder.clone_repo(config)
        expect(File).to exist(File.join(tmpdir, config.project_name))
      end
    end
  end

  context 'change common files' do
    let(:builder) {CarmenBuilds::Builders::Builder}
    let(:config) {create(:config)}
    let(:git) {builder.clone_repo(config)}

    describe '#set_color' do
      it 'will set appColor in CommonColors.js' do
        config.git = git
        path = File.join(git.dir.path, 'js', 'common', 'CommonColors.js')
        builder.set_color(config)
        file = File.read(path)
        expect(file).to include("appColor: '#{config.color}'")
      end
    end

    describe '#set_env_id' do
      it 'will set jsonApiEndpoint in env.js' do
        config.git = git
        path = File.join(git.dir.path, 'js','env.js')
        builder.set_env_id(config)
        file = File.read(path)
        expect(file).to include("jsonApiEndpoint: 'api/mobile/#{config.id}/'")
      end
    end
  end
end
