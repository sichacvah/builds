module Helpers
  def file_path(template, git)
    File.join(fastlane_path(git.dir.path), base_name(template))
  end

  def base_name(template)
    File.basename(template, '.erb')
  end

  def fastlane_path(git_path)
    File.join(git_path, 'fastlane')
  end
end
