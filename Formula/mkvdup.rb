# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.8.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2/mkvdup_darwin_arm64.tar.gz"
      sha256 "f2b9db74dc0af23d295aa1adeaa422ed089c2626335f3bc1eac5aaee0cf6ba47"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2/mkvdup_darwin_amd64.tar.gz"
      sha256 "a2a95781a9635bbfec6dd7f7fe1f9eed4ddc6cfa1bf6d9fb544cf8d40634ec5f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2/mkvdup_linux_arm64.tar.gz"
      sha256 "c033e3800bfe43579177ce635e8690d5cf88a9be848c36af19529c9b0cfd08b4"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.8.2/mkvdup_linux_amd64.tar.gz"
      sha256 "9dcfb2b00ec3c652c623feb31bf24f3d8f47d95fbdd03c2d777a6975497b7287"
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
