{pkgs, template ? "flutter_starter", blank ? false, ...}: {
    packages = [
        pkgs.curl
        pkgs.gnutar
        pkgs.xz
        pkgs.git
        pkgs.busybox
    ];
    bootstrap = ''
        # Clone the Flutter template repository
        git clone https://github.com/codika-io/codika_flutter_templates.git "$out"
        mkdir -p "$out"/.idx
        cp ${./dev.nix} "$out"/.idx/dev.nix
        install --mode u+rw ${./dev.nix} "$out"/.idx/dev.nix
        chmod -R u+w "$out"
    '';
}