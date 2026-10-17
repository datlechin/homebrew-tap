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

  version "0.15.0"
  sha256 arm:          "9c43ed3effb3fb6576d6b4f119949d2040409bd62e70f55307e0c216b822abf3",
         intel:        "04ac5c6f5eeac2c35b6497a1299d08bf631e368808abae6288c0d6281562ba29",
         arm64_linux:  "331aa0d1c1f2ee2bd8d932ce981d3305ac4b4efc0c74bab0ea972a691e9ac38e",
         x86_64_linux: "ad9acd9d67ea3b911a91addbaba86080be5ead4009275291d5d82f6386b91537"

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
