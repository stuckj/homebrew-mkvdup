# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.6.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "993e5720a6da90426fd35d08a3eb012f7e267d6507653f38d0db56ed88a53364"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "00829f0f2b6fbe239344fe698e55705666a238fe7644c309395f1f573d87fae2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.1/mkvdup_linux_arm64.tar.gz"
      sha256 "c983acb0c46c0cb7b287a55aed68c291a832a7a32894df671e790a65259c0ddc"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.1/mkvdup_linux_amd64.tar.gz"
      sha256 "2f3df255cf42cd71a95b8b10da89da178c4e2db2939bbe0ac09c1c4c946a44a2"
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
