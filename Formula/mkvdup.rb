# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "0.9.6"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.6/mkvdup_darwin_arm64.tar.gz"
      sha256 "977ff45eb363a57616146cf12522569888ed8faff6acad4d4970dd292a7730f0"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.6/mkvdup_darwin_amd64.tar.gz"
      sha256 "60033d5143d1f28e626b4eba3b0a89a5cfe36a765aaeabbbfaf81690d509b4d7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.6/mkvdup_linux_arm64.tar.gz"
      sha256 "5cb170dafec30d8c47aa2e8f9f0e7431624580f8bdb1e0e722cbe68d04754abd"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v0.9.6/mkvdup_linux_amd64.tar.gz"
      sha256 "87c70652d1d7d148f6ea173e401c8ecad25e20a18ef7b8628d1a24e71c28bdb8"
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
