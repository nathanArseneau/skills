# Skills

A plugin marketplace (`arseneau-marketplace`) of agent skills.

## Plugins

| Plugin          | Description                                       | Skills                                  |
| --------------- | ------------------------------------------------- | --------------------------------------- |
| `documentation` | Generate and manage project documentation         | `markdown-to-skill`, `pdf-to-markdown`  |
| `utils`         | Utilities that can be used on a day to day basis  | `to-the-point`                          |

## Installation

### Claude Code

Add the marketplace:

```
/plugin marketplace add nathanArseneau/skills
```

Then install the plugin(s) you want:

```
/plugin install documentation@arseneau-marketplace
/plugin install utils@arseneau-marketplace
```

### GitHub Copilot CLI

Add the marketplace:

```bash
copilot plugin marketplace add nathanArseneau/skills
```

Then install the plugin(s) you want:

```bash
copilot plugin install documentation@arseneau-marketplace
copilot plugin install utils@arseneau-marketplace
```
