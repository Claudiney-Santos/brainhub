{
  description = "BrainHub Mobile App - A place to manage BrainFuck code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      androidComposition = pkgs.androidenv.composeAndroidPackages {
        cmdLineToolsVersion = "12.0";
      };
      androidSdk = androidComposition.androidsdk;

    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          flutter
          jdk17
          androidSdk
        ];

        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
      };
    };
}
