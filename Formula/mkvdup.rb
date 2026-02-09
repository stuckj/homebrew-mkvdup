# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "b8bbcb09635e17b383e5722902cae1a3db9e8738255b6e2ce880ad330762bd88"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "577e843dd34c1a1ed8d24932533e9c17b1abc1037e60b80be294edf2e9e570bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0/mkvdup_linux_arm64.tar.gz"
      sha256 "0af708b2a456e931780f78e9cf381d08d56104d589543c173ee148e453cd2e4c"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0/mkvdup_linux_amd64.tar.gz"
      sha256 "391e81a98a9703a4484254cdf9ab6884190f242641e2bf9d60b37125359d4d32"
    end
  end

  # Build from source when formula hasn't been updated yet
  head "https://github.com/stuckj/mkvdup.git", branch: "main"

  depends_on "go" => :build if build.head?

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mkvdup"
      man1.install "docs/mkvdup.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*.md"]
      bash_completion.install "scripts/mkvdup-completion.bash" => "mkvdup"
      zsh_completion.install "scripts/mkvdup-completion.zsh" => "_mkvdup"
      fish_completion.install "scripts/mkvdup.fish"
    else
      bin.install "mkvdup"
      man1.install "mkvdup.1"
      doc.install "README.md", "DESIGN.md", "LICENSE"
      doc.install Dir["docs/*"]
      bash_completion.install "mkvdup-completion.bash" => "mkvdup"
      zsh_completion.install "mkvdup-completion.zsh" => "_mkvdup"
      fish_completion.install "mkvdup.fish"
    end
  end

  test do
    if build.head?
      assert_match "mkvdup", shell_output("#{bin}/mkvdup --help")
    else
      assert_match version.to_s, shell_output("#{bin}/mkvdup --version")
    end
  end
end
