cask "findergitclone" do
  version "1.0.0"
  sha256 :no_check

  url "https://github.com/prakashsewani/finder-git-clone/releases/download/v#{version}/FinderGitClone-#{version}.dmg"
  name "FinderGitClone"
  desc "Clone Git repositories directly from Finder's right-click menu"
  homepage "https://github.com/prakashsewani/finder-git-clone"

  depends_on macos: ">= :sonoma"

  app "FinderGitClone.app"

  postflight do
    system_command "/usr/bin/env",
                   args: ["open", "findergitclone://enable-extension"],
                   input: "",
                   print: false
  end

  uninstall quit: "com.findergitclone.app"

  zap trash: [
    "~/Library/Preferences/com.findergitclone.app.plist",
    "~/Library/Application Support/FinderGitClone",
  ]
end
