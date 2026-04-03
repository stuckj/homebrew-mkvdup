# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.7.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "34636df671734736802364f775c94fe66c6cfc0a3188fcdb80760d7cfc2e6828"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "076abc728f90a1993d4438754bfc66b68d0d87d2435707f46dd11597bf5d34dc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.1/mkvdup_linux_arm64.tar.gz"
      sha256 "d62667eb846efc89eb0e0d818b96afc62f73ea15a4681b4271f5c2589fb39a93"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.1/mkvdup_linux_amd64.tar.gz"
      sha256 "80e532a599f3c2f5bf34f2377d288100b556107894a5de3fb1c4082b131ca60f"
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
