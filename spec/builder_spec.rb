RSpec.describe CarmenBuilds::Builders::Builder do
  let(:builder) {CarmenBuilds::Builders::Builder}
  let(:tmpdir) {builder.tmpdir}
  let(:config) {create(:config)}

  describe '#tmdir' do
    it "create tmp dir" do
      expect(File).to exist(tmpdir)
    end
  end

  describe '#clone_repo' do
    it 'will clone repository to tmp directory' do
      builder.clone_repo(config)
      expect(File).to exist(File.join(tmpdir, config.project_name))
    end
  end

end
