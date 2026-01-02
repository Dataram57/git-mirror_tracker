# Git Mirror Tracker

Version: `0.9.0`

`git-mirror_tracker` is a tool that keep track of your local repositories. It features mechanisms that help you verify if the repository is available on its declared remotes, and also lets you clone and apply earlier saved local config with all saved remotes mentioned.

### Commands

```
Usage: `git-mirror_tracker COMMAND [ARGS...]`

version - Displays application version.

mark [PATHS...] - Adds repository into the tracking list.
demark REPOSITORY_NAME - Removes repository from the tracking list.
list - Lists repositories listed on the tracking list.
update - Captures the current local config from the available repositories of the tracking list.

sync REPOSITORY_NAME [NEW_PATH] - clones the repository from the captured remote server and applies captured local config.
audit [REPOSITORY_NAMES...] - Audits availability of repositories listed in the tracking list.
log - Displays audit logs.

status - Displays currently staged changes.
commit - Commits currently staged changes.
history - Displays history of changes.
git [ARGS...] - Executes `git` with given args at $HOME/.config/git-mirror_tracker/.
```

### Problems

- Forks have the same root commit hashes. `repoPath` and `repoName` is what allows forks to be trated as new repositories. Proper prompts appears when such problem is met.
- `;` is a character that should not be used as it is used as `$separator` in the code.

### TODO

- `sync`: Replace `git clone` with `git init`, `apply local config`, `git fetch`. This ensures compatibilit with tools that read config variables during fetch.

# Installing

## Nix Package

Edit these parts of your config:
```nix
inputs = {
    git-mirror_tracker.url = "github:Dataram57/git-mirror_tracker";
    #Alternative: git-mirror_tracker.url = "git+https://kallithea.dataram57.com/git-mirror_tracker";
    # ... other channels ...
};

# ... stuff...

outputs = inputs @ { ..., git-mirror_tracker , ... }: #...

# ... stuff...

home.packages = [       # or `environment.systemPackages`
    git-mirror_tracker.packages.${pkgs.system}.git-mirror_tracker
    # ... other packages
]
```