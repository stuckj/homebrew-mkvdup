# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.3.4"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.4/mkvdup_darwin_arm64.tar.gz"
      sha256 "05dceee23b7bf554cdbe5c156cc9604aa613149bf49611e4df4998a98a36e1b9"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.4/mkvdup_darwin_amd64.tar.gz"
      sha256 "8a3a4f5c8418b5a6d6035cac9f5544a51bd278c1957924b426efc67ce5df9d0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.4/mkvdup_linux_arm64.tar.gz"
      sha256 "e4b810c65bce6edc52736653c52fce4b0b106d8d4d457c871d82ee38d822cb25"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.4/mkvdup_linux_amd64.tar.gz"
      sha256 "bd8d280001f73acf388d1d85e23414da050cad97f3a43fff66412018db9bc378"
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
