# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.2.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "46c4e044594b80d0cbc3a0ee004f6403144bdca1ca64f681a12c9e59256c09bd"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "63524bf89b79baf2086bd3df97a860942a2921bfbc1390934cfa8868a17ff156"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0/mkvdup_linux_arm64.tar.gz"
      sha256 "8181277c6e75eebfcac56d9aeb5ecedd628be08d10fc4721d0f71d00e84f6525"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0/mkvdup_linux_amd64.tar.gz"
      sha256 "6f60851c9151d718b470406af841ca0220869b08110d9de5834dfb9d8bceddf5"
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
