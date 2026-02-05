# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup-canary (pre-release)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup-canary
#
# The canary version can be installed alongside the stable version.

class MkvdupCanary < Formula
  desc "Storage deduplication tool for MKV files (canary/pre-release)"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.0-canary.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.1/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "776a7f3c96f508424e644ee1b1b1338288279a96260a816cbaa6358c54e7f59a"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.1/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "5d8b8c545b0c4dbb3ec57e10101c568783b92aad90a510d71e0f6e60ca2d40dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.1/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "0cb072a9a8400506151d9b303e0b44cc7fb1a537f87f62c74a890f3b8d66ea1d"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.1/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "60e0c61259487b202520be6e3319cfd5e80d818d5a2ff5e3c7f02fe24cb74591"
    end
  end

  # Build from source when formula hasn't been updated yet
  head "https://github.com/stuckj/mkvdup.git", branch: "main"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mkvdup-canary", ldflags: "-s -w"), "./cmd/mkvdup"
      man1.install "docs/mkvdup.1" => "mkvdup-canary.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*.md"]
      bash_completion.install "scripts/mkvdup-completion.bash" => "mkvdup-canary"
      zsh_completion.install "scripts/mkvdup-completion.zsh" => "_mkvdup-canary"
      fish_completion.install "scripts/mkvdup.fish" => "mkvdup-canary.fish"
    else
      bin.install "mkvdup-canary"
      man1.install "mkvdup-canary.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*"]
      bash_completion.install "mkvdup-completion.bash" => "mkvdup-canary"
      zsh_completion.install "mkvdup-completion.zsh" => "_mkvdup-canary"
      fish_completion.install "mkvdup.fish" => "mkvdup-canary.fish"
    end
  end

  def caveats
    <<~EOS
      This is the canary (pre-release) version of mkvdup.
      The binary is installed as 'mkvdup-canary' to allow side-by-side
      installation with the stable 'mkvdup' package.
    EOS
  end

  test do
    if build.head?
      assert_match "mkvdup", shell_output("#{bin}/mkvdup-canary --help")
    else
      assert_match version.to_s, shell_output("#{bin}/mkvdup-canary --version")
    end
  end
end
