# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.9.3"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.3/mkvdup_darwin_arm64.tar.gz"
      sha256 "9cdb9151ea440037013335b28ff03d4146a5f1c28cd8a00210e6dd8967a0614b"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.3/mkvdup_darwin_amd64.tar.gz"
      sha256 "f77974b61257519eb861780a9c969d0fbfa0f21f06565a2627cdc8665e7796a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.3/mkvdup_linux_arm64.tar.gz"
      sha256 "30f7bfbccf83cc73ca40712abb87cf44e0e3d65f08a59eced39b6930947d98da"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.3/mkvdup_linux_amd64.tar.gz"
      sha256 "1430f4f27ebf12b2dc93bbe014851b740c2703f3537a426af9938e6fdc43e5b1"
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
