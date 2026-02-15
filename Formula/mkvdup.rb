# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.4"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.4/mkvdup_darwin_arm64.tar.gz"
      sha256 "4bf1ca23baf830584c5378c3c7e08957381693f967dbe76b8beee9cd6bf018b2"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.4/mkvdup_darwin_amd64.tar.gz"
      sha256 "2b2b166914c8a85a7923de95c4452e683bbfa0581e37a8af566aae231cfabac1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.4/mkvdup_linux_arm64.tar.gz"
      sha256 "64e0aba0063d7ba28fd1f4a404045fa25826275281941f479869f442ef04f8f6"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.4/mkvdup_linux_amd64.tar.gz"
      sha256 "1812803195d436fa1793725bbb05e6b57ff6fd2d850f36f68df7b8b2a0837620"
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
