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

  version "0.11.0"
  sha256 arm:          "d26b379be4c27326d0543e9b722f8c2461cc5fe0effe422007d1787c2e2c6ebf",
         intel:        "7f924955402a01a2cffa4d36759e6d542aef77e06e068e32ad79eab62b8d2669",
         arm64_linux:  "3b2542e0d74d1f99cf162db450a19b30a61389c1031c69a4cc84b3112187c6c3",
         x86_64_linux: "8dca383fe45d8c6691eafb13bdf53fad1d72fd5803d2ad37092340786c0862bf"

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
  desc "Park and restore your own Claude Code and Codex logins"
  homepage "https://usepitboard.com/"

  # The app carries this same command line and links it to the same place.
  conflicts_with cask: "pitboard-app"

  binary "pitboard-v#{version}-#{arch}-#{os}/pitboard"
  manpage "pitboard-v#{version}-#{arch}-#{os}/pitboard.1"
  bash_completion "pitboard-v#{version}-#{arch}-#{os}/completions/pitboard.bash"
  zsh_completion "pitboard-v#{version}-#{arch}-#{os}/completions/pitboard.zsh"
  fish_completion "pitboard-v#{version}-#{arch}-#{os}/completions/pitboard.fish"

  caveats <<~EOS
    On macOS the menu bar app is the pitboard-app cask, and it includes this command line.
    To switch to it, or to get back an app the old pitboard cask installed:
      brew uninstall --cask pitboard
      brew uninstall --formula --force pitboard
      brew install --cask datlechin/tap/pitboard-app
    The second line removes 0.3.0's formula if it is still there, and does nothing if not.

    To remove Pitboard with the logins it parked, run `pitboard uninstall` before
    `brew uninstall`.
  EOS
end
