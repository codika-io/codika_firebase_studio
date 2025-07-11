# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.jdk17
    pkgs.unzip
    pkgs.curl
  ];
  # Sets environment variables in the workspace
  env = {
    PATH = ["$HOME/.fvm/default/bin" "$HOME/.pub-cache/bin" "/home/user/.local/bin" "/home/user/flutter/bin" "./.flutter-sdk/flutter/bin"];
  };
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        installDependencies = ''
          mkdir -p $HOME/.local/bin/
          curl -fsSL https://raw.githubusercontent.com/leoafarias/fvm/e04a1f455c4db33c4c220a5239acb76c0e132c02/scripts/install.sh | bash
          
          bash .idx/setup-fvm-path.sh

          fvm global 3.29.2 -f
          fvm flutter --version

          dart pub global activate mason_cli
          dart pub global activate flutterfire_cli

          curl -fsSL https://install.codika.dev/install | bash

          curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash
        '';
        build-flutter = ''
          cd /home/user/myapp/android

          ./gradlew \
            --parallel \
            -Pverbose=true \
            -Ptarget-platform=android-x86 \
            -Ptarget=/home/user/myapp/lib/main.dart \
            -Pbase-application-name=android.app.Application \
            -Pdart-defines=RkxVVFRFUl9XRUJfQ0FOVkFTS0lUX1VSTD1odHRwczovL3d3dy5nc3RhdGljLmNvbS9mbHV0dGVyLWNhbnZhc2tpdC85NzU1MDkwN2I3MGY0ZjNiMzI4YjZjMTYwMGRmMjFmYWMxYTE4ODlhLw== \
            -Pdart-obfuscation=false \
            -Ptrack-widget-creation=true \
            -Ptree-shake-icons=false \
            -Pfilesystem-scheme=org-dartlang-root \
            assembleDebug

          # TODO: Execute web build in debug mode.
          # flutter run does this transparently either way
          # https://github.com/flutter/flutter/issues/96283#issuecomment-1144750411
          # flutter build web --profile --dart-define=Dart2jsOptimization=O0 

          adb -s localhost:5555 wait-for-device
        '';
      };
      
      # To run something each time the workspace is (re)started, use the `onStart` hook
    };
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["fvm" "flutter" "run" "-t" "lib/main_dev.dart" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
        android = {
          command = ["fvm" "flutter" "run" "-t" "lib/main_dev.dart" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
      };
    };
  };
}