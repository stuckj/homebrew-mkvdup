# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.5.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "ca18046a8377da9255d20eebc444a6412a7dff58ac963d0ca28b10894b68613b"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "8b3e0217a34195fc1d06c79ccb35f130adb8da22928f2b3ed3657daaee682413"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1/mkvdup_linux_arm64.tar.gz"
      sha256 "beb76d84fecd04aeb91e4e2923b1618021aedf1b1400fb588a94c238c86d12e2"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.5.1/mkvdup_linux_amd64.tar.gz"
      sha256 "13ded589bdffc4410c756ad7593292b075ed951807a425f76943f75e35ec0a49"
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
