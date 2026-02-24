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
  version "1.0.0-canary.7"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.7/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "2de2db1c68f97121df15baf03225ec84d61e0ea3a3f65f44615d08b1475baf6e"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.7/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "bfc783c92322c9e64e11a2115bbe77bc821f725243a07e1243f4aa6d045a0952"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.7/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "2ad70801ff8b390c9c212152563dbfad8a4f2aef30f18bd882ea7effbb840dc8"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.0.0-canary.7/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "93c2caa06f81e6b889e7fdd5c09262aa2611b6696b4252ea30bc9a62d510036d"
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
