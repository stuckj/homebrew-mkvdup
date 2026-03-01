# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.3.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.2/mkvdup_darwin_arm64.tar.gz"
      sha256 "6e09889a6909f289f613abcd452d9b5d17506d74475ec7b1c004034dface20fa"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.2/mkvdup_darwin_amd64.tar.gz"
      sha256 "bd880532f67c46dd1e638347568e13bfbeda0d4a08f776258d9a88a3139384ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.2/mkvdup_linux_arm64.tar.gz"
      sha256 "516e9698e9cbaa34f2f6fdac20a68603a60950d30d0f383841cb2899382646d3"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.2/mkvdup_linux_amd64.tar.gz"
      sha256 "867957601eb8fb9ed9c8c574c9bda1dc270fba5b3a7aca49de8222d721843401"
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
