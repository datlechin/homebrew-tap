cask "tablepro" do
  arch arm: "arm64", intel: "x86_64"

  version "0.11.1"
  sha256 arm:   "b0e31d75a4d71e43d59e115e5549509d4e52a157fe22459f3fb56c7fe0f3d6d3",
         intel: "51fb6d234a951074d7148e60733b19267fe44a9cf66ebc51a6bc58175fe0577a"

  url "https://github.com/datlechin/TablePro/releases/download/v#{version}/TablePro-#{version}-#{arch}.dmg"
  name "TablePro"
  desc "Native macOS database client for MySQL, PostgreSQL, SQLite, and MongoDB"
  homepage "https://github.com/datlechin/TablePro"

  depends_on macos: ">= :sonoma"

  app "TablePro.app"

  zap trash: [
    "~/Library/Application Support/TablePro",
    "~/Library/Preferences/com.TablePro.plist",
  ]
end
