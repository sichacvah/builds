module Helpers
  def file_path(template, git, dest)
    File.join(fastlane_path(git.dir.path, dest), base_name(template))
  end

  def base_name(template)
    File.basename(template, '.erb')
  end

  def fastlane_path(git_path, dest)
    File.join(git_path, dest)
  end
end
