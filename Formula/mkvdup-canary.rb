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
  version "1.1.0-canary.7"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.7/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "cfc6a9c63b991a9cf5f86124d1c75ffc828639771970d0e512c5d3e4cefa9dc1"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.7/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "1117d64db4d9c5f1e539745d82cff116b4211d4559de61559d7ad38c93fd4a3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.7/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "39191c9a48fda65933b7f98198693a578b536f4472b6b16fa5a5e9493d36c84d"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.1.0-canary.7/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "de997574bf80cd78c7ac3e18fafe13d02ad3586c2e125605950d41b97e1c5dcd"
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
