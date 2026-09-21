{
description = "NixOS VM test config";

inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
};

outputs = { self, nixpkgs, ... }: {
  nixosConfigurations.test-vm = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
    ];
  };
};
}
