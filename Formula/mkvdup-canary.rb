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
  version "1.3.3-canary.6"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3-canary.6/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "af4d0970df988e495a648907926628e5a871186cd6c9e845bb89457f3df0de28"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3-canary.6/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "a7d6be26194875cff05baf7cd81d88f39e3e8f6eee98f75471883a856f128735"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3-canary.6/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "e8e6486b38effcde7011765e632b56e1f78e87af20f0315f5e10a96a9a842427"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3-canary.6/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "924348ae8f4e9f34cd10c41d603a6fe12b61c2ffa898a09d7e9222443446f0b8"
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
