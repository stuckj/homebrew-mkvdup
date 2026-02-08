# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup-canary (pre-release)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup-canary
#
# The canary version can be installed alongside the stable version.

class MkvdupCanary < Formula
  desc "Storage deduplication tool for MKV files (canary/pre-release)"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.0-canary.14"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.14/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "419ee432a47bf5821aebcb0533c360ebd1c95c464fdee24190e9f0ae45247cb6"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.14/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "7c06473c0e233cc94ee5f50cbe22d5486ba746a71dd7f73e263b922f6e14a30e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.14/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "dd254ac06f9029a13bf14edae470e063fe36eb7372923f5ee311105d23996e0e"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.14/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "b8c4ba69b4d8db8e476e7bfd8785e00b65a5adfdd1b4b075e3ce1f3d0b9a39c6"
    end
  end

  # Build from source when formula hasn't been updated yet
  head "https://github.com/stuckj/mkvdup.git", branch: "main"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mkvdup-canary", ldflags: "-s -w"), "./cmd/mkvdup"
      man1.install "docs/mkvdup.1" => "mkvdup-canary.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*.md"]
      bash_completion.install "scripts/mkvdup-completion.bash" => "mkvdup-canary"
      zsh_completion.install "scripts/mkvdup-completion.zsh" => "_mkvdup-canary"
      fish_completion.install "scripts/mkvdup.fish" => "mkvdup-canary.fish"
    else
      bin.install "mkvdup-canary"
      man1.install "mkvdup-canary.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*"]
      bash_completion.install "mkvdup-completion.bash" => "mkvdup-canary"
      zsh_completion.install "mkvdup-completion.zsh" => "_mkvdup-canary"
      fish_completion.install "mkvdup.fish" => "mkvdup-canary.fish"
    end
  end

  def caveats
    <<~EOS
      This is the canary (pre-release) version of mkvdup.
      The binary is installed as 'mkvdup-canary' to allow side-by-side
      installation with the stable 'mkvdup' package.
    EOS
  end

  test do
    if build.head?
      assert_match "mkvdup", shell_output("#{bin}/mkvdup-canary --help")
    else
      assert_match version.to_s, shell_output("#{bin}/mkvdup-canary --version")
    end
  end
end
