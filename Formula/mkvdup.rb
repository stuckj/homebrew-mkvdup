# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.3.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "7af5941d5e7165f3032a073fa770a19526c530d83bae7e38772d9984b5784c1d"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "93e199cb8bd55f223c5712a1bfea1340155e72bbed26036ab5bddfa01202670d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0/mkvdup_linux_arm64.tar.gz"
      sha256 "1e91a6188f02054e1dae0977ab15c1a28f5cfff91e190f3af0d750d88613b909"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.3.0/mkvdup_linux_amd64.tar.gz"
      sha256 "4db0e52d42e5cd56861cc67d0cd0a3deef5fdacd0ed333fe62527993d8d6a384"
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
