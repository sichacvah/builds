RSpec.describe CarmenBuilds::Builders::Android::Gradle do
  let(:config) {create(:config)}
  let(:git) {CarmenBuilds::Builders::Builder.clone_repo(config)}
  let(:gradle) {
    config.git = git
    CarmenBuilds::Builders::Android::Gradle.new config
  }

  describe '#set_application_id!' do
    it 'change application id to config.application_id' do
      gradle.set_application_id!
      expect(gradle.file).to include("applicationId \"#{config.application_id}\"")
    end
  end

  describe '#set_version_code!' do
    it 'autoincrement versionCode' do
      version = /versionCode (\d+)/.match(gradle.file)[0].to_i + 1
      gradle.set_version_code!
      expect(gradle.file).to include("versionCode #{version}")
    end
  end

  describe '#increment_patch_ver' do
    it 'increment patch when version have 3 dot separated digits' do
      expect(gradle.increment_patch_ver('0.0.3')).to eq('0.0.4')
    end
  end

  describe '#increment_patch_ver' do
    it 'increment patch when version have 2 dot separated digits' do
      expect(gradle.increment_patch_ver('0.3')).to eq('0.3.1')
    end
  end

  describe '#increment_patch_ver' do
    it 'increment patch when version have 1 dot separated digits' do
      expect(gradle.increment_patch_ver('0')).to eq('0.0.1')
    end
  end

  describe '#increment_patch_ver' do
    it 'set version 0.0.1 if version missing' do
      expect(gradle.increment_patch_ver('')).to eq('0.0.1')
    end
  end

  describe '#set_version_name!' do
    it 'autoincrement versionName' do
      version = /versionName (\".+\")/.match(gradle.file)[1]
      new_version = gradle.increment_patch_ver(version)
      gradle.set_version_name!
      expect(gradle.file).to include("versionName \"#{new_version}\"")
    end
  end
end
