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
  version "1.8.2-canary.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2-canary.1/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "ba7d5b6c917ba3f018763feb0dacbced20466c17b936727dc111f52339ec86b2"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2-canary.1/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "f340cbdd4b937b5d7bab69468c98fda7fefcf333ee97a856d11808d4ddc583c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2-canary.1/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "045134ee0db2771bcd99f4b27cca7ab45d51c41d63c7775a18db3ad72dcabb2b"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2-canary.1/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "a6ecd6f10407a107c119629e3117b7267bbc05b7a07f0ef8f8f7ccec53dcf4c1"
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
