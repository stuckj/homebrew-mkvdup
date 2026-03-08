# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.5.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "a5c7eac230fb9ca9c70ff72fafc273c0f02db51a1d69b8060234e02f1851e666"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "5f61f7b6bc4cf033bcaf7d12d051ee1876ecd4a3bc0b40bbc1d7296f7781d440"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.0/mkvdup_linux_arm64.tar.gz"
      sha256 "202c10851224c80efb26c00989f6b5855dd51da404f984b5e530cac67a20f5c5"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.0/mkvdup_linux_amd64.tar.gz"
      sha256 "7fa9d3b40c6f2f0080f67b6f2ef3f58553829816c5002adfcc42ab9c58164c9d"
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
