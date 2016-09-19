RSpec.describe CarmenBuilds::Builders::Builder do

  describe '#tmdir' do
    it "create tmp dir" do
      begin
        tmpdir = CarmenBuilds::Builders::Builder.tmpdir
        expect(File).to exist(tmpdir)
      ensure
        FileUtils.rm_rf( tmpdir ) if File.exists?( tmpdir )
      end
    end
  end

  describe '#clone_repo' do
    it 'will clone repository to tmp directory' do
      begin
        builder = CarmenBuilds::Builders::Builder

        tmpdir = builder.tmpdir
        config = CarmenBuilds::Config.new do |config|
          config.repo_url = 'git@techinform.pro:carmen_client_app'
          config.project_name = 'carmen_client_app'
        end

        builder.clone_repo(config)
        expect(File).to exist(File.join(tmpdir, config.project_name))
      ensure
        FileUtils.rm_rf( tmpdir ) if File.exists?( tmpdir )
      end
    end
  end

end
