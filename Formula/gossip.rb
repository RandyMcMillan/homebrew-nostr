class Gossip < Formula
  desc "Desktop client for Nostr written in Rust"
  homepage "https://github.com/mikedilger/gossip"
  url "https://github.com/mikedilger/gossip.git",
      tag:      "v0.7.0",
      revision: "7cbb7f5139fc795d2acbff964ed1af037f4e8057"
  license "MIT"
  head "https://github.com/mikedilger/gossip.git", branch: "master"

  option "without-cjk", "Compile without CJK (Chinese, Japanese, and Korean) character sets"
  option "without-rustls", "Compile without rustls and use native TLS provider"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg" => :recommended

  def install
    build_args = ["build", "--release"]
    features = []
    features.push("lang-cjk") if build.with? "cjk"
    features.push("video-ffmpeg") if build.with? "ffmpeg"
    features.push("native-tls") if build.without? "rustls"
    build_args.push("--no-default-features") if build.without? "rustls"
    build_args.push("--features=#{features.join(",")}") unless features.empty?

    system "cargo", *build_args
    cd "target/release" do
      bin.install "gossip"
      if build.with? "ffmpeg"
        libexec.install Dir[shared_library("libSDL2*")]
        libexec.install "libSDL2main.a"
        bin.install_symlink Dir["#{libexec}/*"]
      end
    end
  end
end