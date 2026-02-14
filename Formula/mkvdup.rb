# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.2/mkvdup_darwin_arm64.tar.gz"
      sha256 "30226cdab167c5825da1d405bad3abe4f441fba23c050054a25bf9c0cf364cd7"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.2/mkvdup_darwin_amd64.tar.gz"
      sha256 "ab5df7bed386f811d35cf5d19b03d2c0fb67978ce702a272566c3a8fcc946577"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.2/mkvdup_linux_arm64.tar.gz"
      sha256 "87cce864895a6cf586485697e0288dd024bc12bc9c30ba27d10a8985a353ad57"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.2/mkvdup_linux_amd64.tar.gz"
      sha256 "ad83a43881565e6363dd6bf7f30d039878f622e3c90eb973314203894af0eb90"
    end
  end

  # Build from source when formula hasn't been updated yet
  head "https://github.com/stuckj/mkvdup.git", branch: "main"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mkvdup"
      man1.install "docs/mkvdup.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*.md"]
      bash_completion.install "scripts/mkvdup-completion.bash" => "mkvdup"
      zsh_completion.install "scripts/mkvdup-completion.zsh" => "_mkvdup"
      fish_completion.install "scripts/mkvdup.fish"
    else
      bin.install "mkvdup"
      man1.install "mkvdup.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*"]
      bash_completion.install "mkvdup-completion.bash" => "mkvdup"
      zsh_completion.install "mkvdup-completion.zsh" => "_mkvdup"
      fish_completion.install "mkvdup.fish"
    end
  end

  test do
    if build.head?
      assert_match "mkvdup", shell_output("#{bin}/mkvdup --help")
    else
      assert_match version.to_s, shell_output("#{bin}/mkvdup --version")
    end
  end
end
