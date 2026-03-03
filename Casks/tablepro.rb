cask "tablepro" do
  arch arm: "arm64", intel: "x86_64"

  version "0.12.0"
  sha256 arm:   "2bbfb8311a248d37b4a13fbd9e1442a23a2e6db6579760ba24c18b69d5701176",
         intel: "4c7633eec9bd8072eb437ee89e1cada40dd7af991cd2ff1b432cc18bd5fa68d2"

  url "https://github.com/datlechin/TablePro/releases/download/v#{version}/TablePro-#{version}-#{arch}.dmg"
  name "TablePro"
  desc "Native macOS database client for MySQL, PostgreSQL, SQLite, and MongoDB"
  homepage "https://github.com/datlechin/TablePro"

  depends_on macos: ">= :sonoma"

  app "TablePro.app"

  postflight do
    system "xattr", "-cr", "#{appdir}/TablePro.app"
  end

  zap trash: [
    "~/Library/Application Support/TablePro",
    "~/Library/Preferences/com.TablePro.plist",
  ]
end
