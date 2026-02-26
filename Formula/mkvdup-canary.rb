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
  version "1.2.0-canary.3"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.3/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "61a3ef51ce4b0c09f4ec328a123d67174f423d0780298df91f9312115a5ab3b3"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.3/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "1a81ef197be2d0c9c69b58de85041dd3f011551b7f2c8c42e8b756f12bd0b907"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.3/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "09fb8d152f00c23d22fbb23ee246a1fe25377b129e295c3599a059151c1cb594"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.3/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "191e8cc03bea2f6eeac1ccb7ecfdca79fd104626c0c9f2f042fec84c312a59f3"
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
