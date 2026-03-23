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
  version "1.5.1-canary.5"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.5/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "8bb3748136cfa3952ca64208df32a40219fe12d2de19fbce5f5ffcc7e16f4d2d"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.5/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "60a342de6bb585fb121d10324de48a850bbbc73b2e93565c0cbb80b4de4f4650"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.5/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "fa8585f28d74d3168cc8cd600c6c004dc3191285cb9c84e65ce76f70e25a00fc"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.5/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "5a80d49dc649db46be82eeb6ba9f502bf1c0240c6bf09063778cdcba5da624f9"
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
