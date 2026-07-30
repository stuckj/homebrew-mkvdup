# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.9.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "4590172ae10deecca5f2b7f9c842ee2d3bba29f963e4ecb15e69e11a9042ff43"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "69a1868a7581c74e6e11b8f7f60875f9b34e1073c5b4900bdb28260395b0c997"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.0/mkvdup_linux_arm64.tar.gz"
      sha256 "54c428ecbef3abb0836006cea5851d8000017fc38dc1c47f22e0ab15b1f3b04b"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.9.0/mkvdup_linux_amd64.tar.gz"
      sha256 "beb9a15e3ef37fec388f49829581e92edcfc53e0394b4da94f82a024dab8e41f"
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
