cask "tablepro" do
  arch arm: "arm64", intel: "x86_64"

  version "0.13.0"
  sha256 arm:   "8b96966619a6118f66369d49ba95882f41ccd68b4e59d118330c782929c58fde",
         intel: "4ba61eeaff57a6db2bd654af359298aa664036798be7e3ad50b7ae68ddf8bf4e"

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
