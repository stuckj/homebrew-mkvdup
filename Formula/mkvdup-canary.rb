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
  version "1.2.0-canary.9"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.9/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "55cbcaa0ddaecaeed07c8cb6109cb0a1b865dcec93cf4767adba0b14359a7953"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.9/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "16db82f173bd256646424bf62caf6d09cfdc5914d99d28f24bb347014386c1e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.9/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "df855ff5a90a92fba267a8e698816d66abf89c7e67363f5eecf476f5cc505505"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.0-canary.9/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "73be4c10bf76dd2fb9080c35781a937dd8844349324754b4aac67828ac7cffcd"
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
