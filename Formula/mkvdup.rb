# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.5"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.5/mkvdup_darwin_arm64.tar.gz"
      sha256 "3a73d04b250d2e3a85db3072cdf5ae62b46ba8ced80257102109363da5ff836a"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.5/mkvdup_darwin_amd64.tar.gz"
      sha256 "8986fcde6e94f358807d72f20ff229502c23ad4dc6ffb95c7ad8af991cc62038"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.5/mkvdup_linux_arm64.tar.gz"
      sha256 "c5357a7a3107ec33c5331da450ac397e3879227cd9b987e4e208c2f85d8dc5fd"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.5/mkvdup_linux_amd64.tar.gz"
      sha256 "7555b1845b7867fbcb38426e784b324092e7e33a668b28f796005e953fe54432"
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
