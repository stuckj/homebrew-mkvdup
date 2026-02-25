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
  version "1.1.0-canary.6"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.6/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "7a2cc76a0442e15eb8c46c0769de8f3910cf24cbe8f750455a8e1913da0ddf50"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.6/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "debeaf4dd2cd8743d1381d423b00562b538d805b44ca26475cadb4b10a47b191"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.6/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "bbc029fb91fb9bbc9a7745104fe315f935c8c61f1977bc0d6a960239f394c5c2"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.6/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "ad7a4b1b522b15239553a82a567e10ca9f1cbb51efa3cbce754d0eee793fcb5b"
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
