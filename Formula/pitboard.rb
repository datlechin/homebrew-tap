# Homebrew formula for the tap datlechin/homebrew-tap.
#
# It builds from source on purpose. The released binaries are signed ad hoc, and a local
# build carries no quarantine flag at all. Update url, sha256 and version on each release
# with packaging/update-tap.sh.
class Pitboard < Formula
  desc "Park and restore your own Claude Code logins"
  homepage "https://github.com/datlechin/pitboard"
  url "https://github.com/datlechin/pitboard/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "2dfdcb0df5c0bc1f8c61046072ad39f71b2bfd31f93d4672169821d3168c972c"
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
