# typed: false
# frozen_string_literal: true

# Homebrew formula for mkvdup (stable)
# This file is auto-updated by the release workflow.
# To install: brew tap stuckj/mkvdup && brew install mkvdup

class Mkvdup < Formula
  desc "Storage deduplication tool for MKV files and their source media"
  homepage "https://github.com/stuckj/mkvdup"
  license "MIT"
  version "1.2.1"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1/mkvdup_darwin_arm64.tar.gz"
      sha256 "2e48100b05d4aaf85fd6d812d47525c3ed180ca10be50ff6f0feaff4b403e65c"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1/mkvdup_darwin_amd64.tar.gz"
      sha256 "dc9bd74379fe024002b35252ba634f5f1a0606263d3c918572bd3c0ec2d6e84c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1/mkvdup_linux_arm64.tar.gz"
      sha256 "3e726abd6ca1b5865061813b4da237a79f85aa1842a522294c4cd47171b7344c"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1/mkvdup_linux_amd64.tar.gz"
      sha256 "fd6dc81ff8ba6526dbff2188e54beedf8e1a56593b45ba3b8c05c1390a1032ca"
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
