# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.3.3"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3/mkvdup_darwin_arm64.tar.gz"
      sha256 "91259402721a96b3fc7d2fe3c1ae3ae89d7b50510998dc70c9ce743b48128112"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3/mkvdup_darwin_amd64.tar.gz"
      sha256 "d3f403554ae3f3a3b099567e34586870a9ce2bf4fb374bb82ff4bc72dd3afad3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3/mkvdup_linux_arm64.tar.gz"
      sha256 "c73c98e486cc5350a8a27766570529ed1f182a86b19bf8d90ebad21c7bf1b4c3"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.3/mkvdup_linux_amd64.tar.gz"
      sha256 "4c7da6e73d1aa8923d5bc53fbb9d1e8ce4ed1451bfad113b470124fcf0d498eb"
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
