# nix-darwin and home-manager settings

## TODOs

### mac

- [ ] laptop keymaps (karabiner)

### generic

- [ ] zsh profile should be modularised

## setup notes

### darwin

- install nix multi-user
- setup fonts? (manually)
- `./apply`
- ???
- profit

### mac post setup

#### keyboard settings

- shortcuts -> mission control -> move space / switch desktop off
- bind capslock to control

### WLS post setup

- bind capslock to control

## nixos setup

```
just
```

## claude post setup

> https://github.com/anthropics/claude-code/issues/14803#issuecomment-3725184443

manually delete startupTimeout for kotlin and java LSP plugins from `~/.claude/plugins/marketplaces/claude-plugins-official/.claude-plugin/marketplace.json`
