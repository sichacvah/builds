require 'carmen_builds'

RSpec.describe CarmenBuilds::Builders::Builder, "#clone_repo" do
  context "cloning repo from github" do
    it "cloning repo to the tmp dir" do
      tmpdir = CarmenBuilds::Builders::Builder.tmpdir
      config = CarmenBuilds::Conifg.new do |config|
        config.repo_url = "git@techinform.pro:carmen_client_app"
      end

      CarmenBuilds::Builders::Builder.clone_repo

      expect(tmpdir)
    end
  end
end
