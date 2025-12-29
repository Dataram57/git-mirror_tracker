# Git Mirror Tracker (WIP)

`git-mirror_tracker` lets you keep track of where your repositories are remotely stored.

### Problems?

- Forks have the same root commit hashes. repoPath and repoName is what can then distinguish these repos.


# Installing

## Nix Package

Edit these parts of your config
```nix
inputs = {
    Dataram57_git-mirror_tracker.url = "github:Dataram57/git-mirror_tracker";
    # ... other channels ...
};

# ... stuff...

outputs = inputs @ { ..., Dataram57_git-mirror_tracker , ... }:

# ... stuff...

home.packages = [       # or `environment.systemPackages`
    Dataram57_git-mirror_tracker.packages.${pkgs.system}.git-mirror_tracker
    # ... other packages
]
```