# Homebrew formula for the tap datlechin/homebrew-tap.
#
# It builds from source on purpose. The released binaries are signed ad hoc, and a local
# build carries no quarantine flag at all. Update url, sha256 and version on each release
# with packaging/update-tap.sh.
class Pitboard < Formula
  desc "Park and restore your own Claude Code logins"
  homepage "https://github.com/datlechin/pitboard"
  url "https://github.com/datlechin/pitboard/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "913bb3d08d210000888d61acb2596a089c50086dc8116d8bad07a97da690ce94"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/pitboard")
    generate_completions_from_executable(bin/"pitboard", "completions")
    (man1/"pitboard.1").write Utils.safe_popen_read(bin/"pitboard", "manpage")
  end

  test do
    assert_match "pitboard", shell_output("#{bin}/pitboard --version")
  end
end
