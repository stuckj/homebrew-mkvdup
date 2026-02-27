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
  version "1.2.0-canary.6"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.6/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "2ddb689ae1088e6ae59abd574da1736efbfef1bc0ac998f9ef480e27afc75ca2"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.6/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "1dc3fc293a47390a2af5bf9078ae90630c79de255e9ae4fa6041374f0d3d08b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.6/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "8928148e044599a9d33f601b63cc276877bd211fc7a5e0abaa344310c8da8a3c"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.6/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "57d9ff0915b188e17a09e5d1691f33f3cd7ba3d6498745ce5548dc02ef1ec046"
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
