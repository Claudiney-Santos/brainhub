{
  description = "BrainHub Mobile App - A place to manage BrainFuck code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      android = pkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "35" ];
        buildToolsVersions = [ "35.0.0" ];

        includeNDK = true;
        ndkVersions = [ "28.2.13676358" ];

        cmakeVersions = [ "3.22.1" ];
      };

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          flutter
          jdk17
          android.androidsdk
        ];

        ANDROID_SDK_ROOT = "${android.androidsdk}/libexec/android-sdk";
        ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
        ANDROID_NDK_ROOT = "${android.androidsdk}/libexec/android-sdk/ndk/28.2.13676358";

        JAVA_HOME = "${pkgs.jdk17}";
      };
    };
}
