# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.8.10"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10/mkvdup_darwin_arm64.tar.gz"
      sha256 "52cc9861fc16ec67e01d4b7cf7153467cb10ad2171c0c6bc83539987227d9688"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10/mkvdup_darwin_amd64.tar.gz"
      sha256 "4709816838a3301a64be65306f27073bfbefe8dcc8f2ad65fdc094255f1ba556"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10/mkvdup_linux_arm64.tar.gz"
      sha256 "f6774945a5eed72b3e54c77a2e9c27eabef916b0b2ad1ad633efbc8b58a8e455"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10/mkvdup_linux_amd64.tar.gz"
      sha256 "0c5fd41a6e109016e5627b004ad05bbe8a2c2529476b9e6bc18bd671e18222fd"
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
