# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.6.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "c5715253bca54b0380de6d40a0392923c43b2bb67be170c472ec363d099aff4a"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "9799df9a9da21bba22ff17270c756eefb19457c6f7cf81458610b754ed311f0c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.0/mkvdup_linux_arm64.tar.gz"
      sha256 "6079846458972cad5dac1c33fa0b4fe415ccf62f7943d0c21df4129ec0717038"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.6.0/mkvdup_linux_amd64.tar.gz"
      sha256 "3436eb384631725c31f84f6e0e88225d573f5777c34b764d83cb3838e4f6323b"
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
