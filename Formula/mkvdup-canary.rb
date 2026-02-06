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
  version "0.9.0-canary.5"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.5/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "9629044eef344e0208b17db45fdfdf5eaa31e079a848ad266959f99165e132ac"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.5/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "7d51dab13e132cc1d8cc97ca1f8af46eda542eb9ef1029bd1c4c1c56fbbce9b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.5/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "19ba33d6acd4cccd05df7126be6866e50553c4ba43c510efff44aaf1c8da1b7b"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.0-canary.5/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "f9beb2fc60a80de06571e83625a68d123cc3669aa32c31395b95628c1efbac2d"
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
