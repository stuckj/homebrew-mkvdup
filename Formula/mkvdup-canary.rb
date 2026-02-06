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
  version "0.9.0-canary.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.2/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "d4e33271038ef17fc0a35aa537e46c3ad5d99a6e569826dce8daa190496744f9"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.2/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "0768c0ae4a9a98920ecaf7c1362554873dae30ce7ceb5ba273775cf13d06b325"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.2/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "28d0447767a747e41f57d68c8f377ecb981dbd22b224b7534e89a3d457c784e9"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.2/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "10f2941ce1edb94232d8fb7bc5cf97c1256d2aed949b67d93f72f79f347b3d81"
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
