# Nix Config 


## Configuration Structure

My current nix configuration's structure is as follows:

```bash
› tree
.
├── flake.lock  # a lock file generated by nix
├── flake.nix   # the entry point of the nix configuration
├── home        # home-manager's configuration folder, help you manage your dotfiles & user-level apps.
│   ├── shell.nix    # customize zsh's dotfiles
│   ├── core.nix     # user-level apps from nixpkgs(nix's official package repository)
│   ├── default.nix  # home-manager's entry point.
│   ├── git.nix      # customize git's dotfiles
│   └── starship.nix # customize starship's dotfiles
├── Taskfile    # a go-task nix config dev-workflow.
├── README.md
├── modules     # contains all the nix configuration files
│   ├── apps.nix        # contains the homebrew & nix apps(both GUI & CLI)
│   ├── host-users.nix  # defines hostnames & system users
│   ├── nix-core.nix    # nix's core configuration
│   └── system.nix      # defines macOS's system configuration(like dock, trackpad, keyboard, finder, loginwindow, etc.)
└── scripts
    └── darwin_set_proxy.py  # a script to set http proxy for nix & homebrew.
```
