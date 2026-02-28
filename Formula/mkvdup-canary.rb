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
  version "1.2.1-canary.2"

  on_macos do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1-canary.2/mkvdup-canary_darwin_arm64.tar.gz"
      sha256 "d16976ad61a6dc4a3c9ce0c9a938a97a18ab1edbb1d4f7fbbe3196b25a4887a3"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1-canary.2/mkvdup-canary_darwin_amd64.tar.gz"
      sha256 "38ade4f39546cecd252b29a70d72d5ae30759226fd3b7a62ad1ce7ba15b76860"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1-canary.2/mkvdup-canary_linux_arm64.tar.gz"
      sha256 "546457e07ffa8ec9403738e8949cddf08bef4ccdc55fd788926427a3e3ef6ef7"
    end
    on_intel do
      url "https://github.com/stuckj/mkvdup/releases/download/v1.2.1-canary.2/mkvdup-canary_linux_amd64.tar.gz"
      sha256 "efa33d2a1d7b9186d06c4cfe08feba27f350431c323f1e7e43c04f4a701c32f0"
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
