{pkgs, template ? "flutter_starter", blank ? false, ...}: {
    packages = [
        pkgs.curl
        pkgs.gnutar
        pkgs.xz
        pkgs.git
        pkgs.busybox
    ];
    bootstrap = ''
        # Install FVM
        mkdir -p $HOME/.local/bin/
        curl -fsSL https://raw.githubusercontent.com/leoafarias/fvm/e04a1f455c4db33c4c220a5239acb76c0e132c02/scripts/install.sh | bash || true
        
        # Add FVM to PATH
        export PATH="$HOME/.local/bin:$HOME/.pub-cache/bin:$PATH"
        echo 'export PATH="$HOME/.local/bin:$HOME/.pub-cache/bin:$PATH"' >> $HOME/.bashrc

        # Install Flutter
        fvm global 3.29.2 -f || true
        fvm flutter --version || true

        # Install Mason and Flutterfire
        fvm dart pub global activate mason_cli || true
        fvm dart pub global activate flutterfire_cli || true

        # Install Codika CLI
        curl -fsSL https://install.codika.dev/install | bash || true

        # Install Shorebird CLI
        curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash || true

        # Create Flutter project directly using the Nix-provided Flutter
        fvm flutter create "$out" || true
        mkdir -p "$out"/.idx
        cp ${./dev.nix} "$out"/.idx/dev.nix
        install --mode u+rw ${./dev.nix} "$out"/.idx/dev.nix
        chmod -R u+w "$out"
        
        # Add a note that FVM will be set up when loaded in Workstations
        echo "# FVM will be configured when this project is loaded in Cloud Workstations" >> "$out"/README.md
    '';
}