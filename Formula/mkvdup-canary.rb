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
  version "0.8.10-canary.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10-canary.2/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "4f483097768bde2536e23a260695b644580f61a0cf376b0beb96e9f6cab789d2"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10-canary.2/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "6041d07d454c5d4f15d47c058aadd08cf8f86c2aa080652f759221679fdde217"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10-canary.2/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "f2adbeeb68fc378b72e521384fda0be5e222fac58bbe5556cb34b9d809a34a37"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.8.10-canary.2/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "553c490dbf7270122eb7be9153d6e10726c2fb5b7f3415477240b422091c4148"
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
