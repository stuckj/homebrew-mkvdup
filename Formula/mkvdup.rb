# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.3"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.3/mkvdup_darwin_arm64.tar.gz"
      sha256 "237616afdeb1d5cd1b093f7f240f5860a2fbe1462afdbcde2af6ec9c0654790a"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.3/mkvdup_darwin_amd64.tar.gz"
      sha256 "682adee7ca0f6acba8e0b0c3dd7b6fffdd0d65c14e7d54410e09c0ea4cbdd7fa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.3/mkvdup_linux_arm64.tar.gz"
      sha256 "c0eb9267eb44b08a8b308f6a82d0e6b4fc506ec9ef61922db0187c4bfe7c7d7d"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.3/mkvdup_linux_amd64.tar.gz"
      sha256 "62c53719ae49837f5fbb9c885f61d96c56d27df24e89fdee28cb6668cb8b1b42"
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
