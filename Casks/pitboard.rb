# Homebrew cask for the menu bar app, for the tap datlechin/homebrew-tap.
#
# The download is the notarised build from the release, so Gatekeeper accepts it with no
# further step. Sparkle keeps it up to date afterwards, which is why auto_updates is set.
cask "pitboard" do
  version "0.1.4"
  sha256 "12550acba173b6b70791090dab6f39396ba48b6409ac7bfa661bf1ccae96b782"

  url "https://github.com/datlechin/pitboard/releases/download/v#{version}/Pitboard-v#{version}-macos.zip"
  name "pitboard"
  desc "Menu bar view of every Claude account's limits, and one click to switch"
  homepage "https://github.com/datlechin/pitboard"

  auto_updates true
  depends_on macos: :sonoma

  app "Pitboard.app"

  zap trash: [
    "~/.pitboard",
    "~/Library/Application Support/com.usepitboard.Pitboard",
    "~/Library/Caches/com.usepitboard.Pitboard",
    "~/Library/Preferences/com.usepitboard.Pitboard.plist",
  ]
end
