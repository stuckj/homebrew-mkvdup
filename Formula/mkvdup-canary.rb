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
  version "1.0.0-canary.3"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.3/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "f7b0cb695be491cf5634e83696b0572ed48f86ce236230d69275901c2addc099"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.3/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "87d07ae7ae1b0720cfd29e1892c2ebc4e826b4f07ebcab3a54d30baa83b93a54"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.3/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "82f9292d2423a456635526cee91a05e100fe0a0435231c9a705ede7dd349001f"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.3/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "4696257efb100f793596be5c693c196797e159f4d07eea0f90d092c4c05388a3"
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
