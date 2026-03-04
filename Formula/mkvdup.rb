# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.3.5"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.5/mkvdup_darwin_arm64.tar.gz"
      sha256 "a45061b0732627cd6cea2b0052c68d4bf1794bb69ab9e7a10d2f9eef70a0fa8e"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.5/mkvdup_darwin_amd64.tar.gz"
      sha256 "b01037ca9cfce052d20e1a548055947ad0d2610dd3b6f0df1d3f7df5aad25e61"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.5/mkvdup_linux_arm64.tar.gz"
      sha256 "a1e6991fa0307f1a7b335bc722ddc56b48df252e1bba5f831ac7c9b5b4eadc69"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.5/mkvdup_linux_amd64.tar.gz"
      sha256 "d462c4ac9f4de5fed6765b4319c6cf4a46f35f842fa2d73f407252a2f03daa92"
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
