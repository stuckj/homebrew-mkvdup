# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.6.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.2/mkvdup_darwin_arm64.tar.gz"
      sha256 "cd15a7332e2975987473332a7235e4f6fe072e147e47b862848ec7bfb00a0818"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.2/mkvdup_darwin_amd64.tar.gz"
      sha256 "0bd0eac62b2b8bc7c95f191adb0005867a8cee1976c5b8c9154fa6c54fbbc7c4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.2/mkvdup_linux_arm64.tar.gz"
      sha256 "6fb11904770a6f3da0df05637e8aa8198782ef54c08359d5f47114fc522c84b6"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.2/mkvdup_linux_amd64.tar.gz"
      sha256 "91d7d0ea082884161ef0379eade9bdbf4ab9f25104144419ce8968281e9df69f"
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
