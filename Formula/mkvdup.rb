# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.4.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "5ae47c3669d50ac49463f31b4668d601b0c5f7b637eff067b6adbf5dafbffa63"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "663afc8a2277db0ac36ab99a63b9911ec1036bcee98da406add9c92e7211e7d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.0/mkvdup_linux_arm64.tar.gz"
      sha256 "2bea0f4b4320a1cf5ae7e83e8a668a41af801634e772a7164c9f1b9a17b73171"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.4.0/mkvdup_linux_amd64.tar.gz"
      sha256 "d5885218075772c1b2ff092c943ed2ef8df065cd36332da44957ebd3bbf6537b"
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
