# Homebrew cask for the command line on macOS and Linux, in the tap datlechin/homebrew-tap.
#
# Pitboard's release writes the tap's copy from packaging/pitboard.rb in datlechin/pitboard,
# with the version and the checksums from the release's SHA256SUMS filled in. An edit made
# to the tap's copy is replaced at the next release.
#
# The download is the release's own tarball for the machine, attested, and on macOS signed
# and notarised, so nothing is built and nobody needs Rust.
cask "pitboard" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "apple-darwin", linux: "unknown-linux-musl"

  version "0.14.0"
  sha256 arm:          "712733f4ea7628d7131b0d3c94b9a52c0f06c6dd9911a5d390cc286602b2f334",
         intel:        "a532e8d503a87575adbdb5c92ac8b45eaa81a1d6bc3e3aed50d652bd1c472664",
         arm64_linux:  "ec0771e0639ba55b85aab23485ca2385879e27746c17f54e4cf5328643dcbee1",
         x86_64_linux: "6693e79975e3ac91d20e952f3476a2d994b48de926120907db6d1e4bfe6fe7c7"

  # The renewal schedule, the launchd job on macOS and the systemd timer on Linux. In zap
  # and not uninstall, because Homebrew runs uninstall on every upgrade and reinstall too.
  # ~/.pitboard stays: it is the only index of the parked logins, and without it they are
  # left where nothing can name them. `pitboard uninstall` deletes the logins and then the
  # directory, so it has to come first. It is up here because Homebrew's style puts blocks
  # for one system straight after the checksums.
  on_macos do
    zap launchctl: "com.datlechin.pitboard.renew"
  end
  # A timer systemd has loaded keeps firing after its files are deleted, so it is stopped
  # first. Homebrew runs the script without XDG_RUNTIME_DIR, and systemctl --user cannot
  # reach the user's manager without it. Where there is no timer, there is nothing to stop.
  on_linux do
    zap script: {
          executable:   "/bin/sh",
          args:         [
            "-c",
            "test ! -e ~/.config/systemd/user/pitboard-renew.timer || " \
            "XDG_RUNTIME_DIR=/run/user/$(id -u) systemctl --user disable --now pitboard-renew.timer",
          ],
          must_succeed: false,
        },
        trash:  [
          "~/.config/systemd/user/pitboard-renew.service",
          "~/.config/systemd/user/pitboard-renew.timer",
          "~/.config/systemd/user/timers.target.wants/pitboard-renew.timer",
        ]
  end

  url "https://github.com/datlechin/pitboard/releases/download/v#{version}/pitboard-v#{version}-#{arch}-#{os}.tar.gz"
  name "Pitboard"
  desc "Switch Claude Code, Codex and Claude Desktop between your own accounts"
  homepage "https://usepitboard.com/"

  # The app carries this same command line and links it to the same place. Homebrew 7.0.6 has
  # no conflicts_with formula:, so 0.3.0's formula cannot be named here.
  conflicts_with cask: "pitboard-app"

  binary "pitboard-v#{version}-#{arch}-#{os}/pitboard"
  manpage "pitboard-v#{version}-#{arch}-#{os}/pitboard.1"
  bash_completion "pitboard-v#{version}-#{arch}-#{os}/completions/pitboard.bash"
  zsh_completion "pitboard-v#{version}-#{arch}-#{os}/completions/pitboard.zsh"
  fish_completion "pitboard-v#{version}-#{arch}-#{os}/completions/pitboard.fish"

  caveats <<~EOS
    On macOS the menu bar app is the pitboard-app cask, and it includes this command line.
    To switch to it:
      brew uninstall --cask pitboard
      brew install --cask datlechin/tap/pitboard-app
    If this replaced an app the old pitboard cask installed, see
    https://docs.usepitboard.com/install/upgrade-from-0-3-0

    To remove Pitboard with the logins it parked, run `pitboard uninstall` before
    `brew uninstall`.
  EOS
end
