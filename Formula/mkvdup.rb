# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.7.0"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.0/mkvdup_darwin_arm64.tar.gz"
      sha256 "8d329b17141a6d1ade1eeb0e8c6a9634cdec406764fecb405a10e77a75c6ce01"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.0/mkvdup_darwin_amd64.tar.gz"
      sha256 "933848ec0c89c2aafc4ddb42077b471fa5d04d55d8e1f259b304e9fff13eff21"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.0/mkvdup_linux_arm64.tar.gz"
      sha256 "7f800dc9527df88cb02d6e52acab3185fe3b7cb18bf9471f5c0e20c31ead66cd"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.7.0/mkvdup_linux_amd64.tar.gz"
      sha256 "f7b0283a566a36e42d56b37f1f0be1143ad937ee723b13898743589aadf9d461"
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
