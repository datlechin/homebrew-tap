cask "tablepro" do
  arch arm: "arm64", intel: "x86_64"

  version "0.14.0"
  sha256 arm:   "596bf4492bc30ba6391ae1e9d7b87fe42866c8418e74e686b5aca84cf82051e4",
         intel: "8b67ca33d74359e325c2c51d624caa50e9d10c48986b0360981d4b44833b4d15"

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
    "~/Library/Caches/com.TablePro",
    "~/Library/HTTPStorages/com.TablePro",
    "~/Library/Preferences/com.TablePro.plist",
  ]
end
