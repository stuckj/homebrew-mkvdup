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
  version "1.3.0-canary.3"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0-canary.3/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "51b300f6f24cf3b9d1e90f9d571f42cedb9b43ca4fec60f7a8faae3bb09e8c26"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0-canary.3/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "c93a0c8540dc44c883d64d2e91211b2db05af3427fcbb0836e0ce8ab6ce24958"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0-canary.3/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "bd363cc7e065fc08c5e10e5ab17b9a26c30bd2f529b0ea6c2b454db0a20b4636"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0-canary.3/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "77bd682a0fa49841092f3a1d652b464a7be3690b98f13c44878be4131a4eb42f"
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
