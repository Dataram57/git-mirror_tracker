# TODO

- `sync`: Replace `git clone` with `git init`, `apply local config`, `git fetch`. This ensures compatibilit with tools that read config variables during fetch.

# Problems

- Forks have the same root commit hashes. `repoPath` and `repoName` is what allows forks to be trated as new repositories. Proper prompts appears when such problem is met.
- `;` is a character that should not be used as it is used as `$separator` in the code.

# Improvements

- A record should be made of (`repoName`, `repoId`) as `repoPath` would change very often by calling `sync` causing massive disruptions and potential clonning to bad folder.