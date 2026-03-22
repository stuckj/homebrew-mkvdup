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
  version "1.5.1-canary.4"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.4/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "a2c843cb1f988b0d84ea36bd5ccd30262068f3b0e98e08ada20c2d749b7dc0e6"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.4/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "92e15d77fa0b1995f024215240c7aebcb70e6ff39eda869603ef85a93e9d4193"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.4/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "a7bc69ec94a15d4aba2497f17551b2e11f6b2e8b32434f1d21e611038c9899a5"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1-canary.4/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "a24eea2a9df1bc70dc7ce6a71cca849dd8f8ec44c35acccdd477aba51595b321"
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
