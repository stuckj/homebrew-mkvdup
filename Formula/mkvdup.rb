# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.5.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.2/mkvdup_darwin_arm64.tar.gz"
      sha256 "da3a6392ac531f311dae5893b76fcb88063376936b269b4e44fe5a9200b0c523"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.2/mkvdup_darwin_amd64.tar.gz"
      sha256 "6df795b0816ba941eaadbcd668753f8959cf8d3d828b36229f642cb7896a1c2f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.2/mkvdup_linux_arm64.tar.gz"
      sha256 "c32ee04ccd868413bfe7ef1bc598d672a1f0ae3ad20316b2c600f3989ddad482"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.2/mkvdup_linux_amd64.tar.gz"
      sha256 "ddcf1c7f711598317b7376dacaebcec8c164c012e4a6bd4275a1041be25405b3"
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
