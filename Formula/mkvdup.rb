# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.9.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "0ca1b7ad211ef726f25d7271b3bef8b437f61fc2269322536384e24a2acce873"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "0df91988fa0f62da61380c114af47622cac5d59fa9ab2d573002c6efc4e261a4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.1/mkvdup_linux_arm64.tar.gz"
      sha256 "69afc84c51db203a632c77dc35eeea8e0afa4401ebed0d2fa795197c432e7b64"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.1/mkvdup_linux_amd64.tar.gz"
      sha256 "2bee1a0d92ad06929e22ec3bcd4be6784e7a86891e8aa83302eec5d83dba0090"
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
