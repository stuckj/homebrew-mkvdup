# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.4.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "87472159a6c4eab85f15f8b1c4e5abc7610491f851e2528792e961d682dda34e"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "28ac90186521fdab6cb14e946e258db6b8fb942a147ceb55c33234bae7b5e942"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.1/mkvdup_linux_arm64.tar.gz"
      sha256 "a7ce29e38afdd2240e3bb1361252bc4f862177d22cb99de385b58d6fec08d3cd"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.1/mkvdup_linux_amd64.tar.gz"
      sha256 "3490ab1c8b26b2e921b6464e5474114a4f706c63552c24dd66ab4247c8efd7d8"
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
