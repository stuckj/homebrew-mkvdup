# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "9de547601af8fc7ec80a459be1d7f85918a1c2e7a15bf5ebd673ec70448eb499"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "609d41164f3170845fc52e95a63ff7ec3cad66b15919ee8c19fa0eeaf3a9460f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.1/mkvdup_linux_arm64.tar.gz"
      sha256 "b3e18e97d4f75983842afae7bef0afba95eba49fbb82e21202640624711db075"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.1/mkvdup_linux_amd64.tar.gz"
      sha256 "49f88354d5c53f8ed8b72f5bb1c6876f3587b87d5983423ff79c32e2f2b72ff2"
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
