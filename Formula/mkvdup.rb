# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.3.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "475c30106e0f47deeea08324a9cd84d07ea4303afe109fdf2d572c05a3308ed5"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "5c6c452a6b575836ca284f36019c27d4a2830de832e8dfa0f1293b892aaa450d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.1/mkvdup_linux_arm64.tar.gz"
      sha256 "74d477d7bfdf27b9447f0117dac6ed50fdf40440c494e7d7052e2c63139a27ec"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.1/mkvdup_linux_amd64.tar.gz"
      sha256 "d20786f7c760ca62e3ca394070a8ad019647372fa41a5a20d4c9fcbc1f8a35da"
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
