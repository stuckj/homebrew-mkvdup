# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.7"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.7/mkvdup_darwin_arm64.tar.gz"
      sha256 "c7417ef793fdfe7c1cbf660f3708a02ef79562a458a1e5e51d276b49a0f560c8"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.7/mkvdup_darwin_amd64.tar.gz"
      sha256 "e62102f4994327e912e03d4ed66542b3305b83624fb067d93c8cec169f185e16"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.7/mkvdup_linux_arm64.tar.gz"
      sha256 "5e1fd7299eb8077f43408f4c40b9f9588afa2dde2ddb4143ca8f05d167a69456"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.7/mkvdup_linux_amd64.tar.gz"
      sha256 "f312f54f74b5ccdd78e2d2693a2bb4111b544a6fee5ccaa5370b53286e7abb9d"
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
