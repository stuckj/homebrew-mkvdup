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
  version "1.1.0-canary.4"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.4/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "189ced015a6051552cfd2a02816f2560a5fbd0e9141cfb677dfa77a53e3efafe"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.4/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "3adc96023d9cfb653eb15202821baa223313bed7cea05e98e6679b1daa00cb0e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.4/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "f02fd9b3cb8475bbfa4a2f8570026418dcc4747241fbb9000259befb1fb4eda7"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.4/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "917011c163735d8e85bc36430fe347a959358ce2499aa69a0b2c164bb18341c5"
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
