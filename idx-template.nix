{pkgs, template ? "flutter_starter", blank ? false, ...}: {
    packages = [
        pkgs.curl
        pkgs.gnutar
        pkgs.xz
        pkgs.git
        pkgs.busybox
        # Add Flutter SDK directly instead of relying on FVM initially
        pkgs.flutter
    ];
    bootstrap = ''
        # Create Flutter project directly using the Nix-provided Flutter
        flutter create "$out"
        mkdir -p "$out"/.idx
        cp ${./dev.nix} "$out"/.idx/dev.nix
        install --mode u+rw ${./dev.nix} "$out"/.idx/dev.nix
        chmod -R u+w "$out"
        
        # Add a note that FVM will be set up when loaded in Workstations
        echo "# FVM will be configured when this project is loaded in Cloud Workstations" >> "$out"/README.md
    '';
}