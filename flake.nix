{
  description = "Minecraft modpack development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          packwiz
          jdk21      # Minecraft 1.21.x のModpackなら
          jq         # JSONいじりに便利
        ];

        shellHook = ''
          echo "Modpack dev shell ready"
          echo "  packwiz: $(packwiz --version 2>/dev/null || echo installed)"
          echo "  java:    $(java -version 2>&1 | head -1)"
          if [ ! -f .gitignore ]; then
            cat > .gitignore << 'EOF'
        # Nix
        .direnv/
        result
        result-*
        
        # Packwiz
        mods/*.jar
        
        # Codex
        .codex/
        EOF
            echo "direnv: .gitignoreを作成しました"
          fi
        
          if [ ! -f .packwizignore ]; then
            cat > .packwizignore << 'EOF'
        .direnv/
        flake.nix
        flake.lock
        .envrc
        .packwizignore
        *.md
        EOF
            echo "direnv: .packwizignoreを作成しました"
          fi
        '';
      };
    };
}
