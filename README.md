# Fork from [https://gitlab.com/itaranto/plantuml.nvim](https://gitlab.com/itaranto/plantuml.nvim)

# plantuml.nvim

This Neovim plugin allows using [PlantUML](https://plantuml.com/) to render diagrams in real time.

This plugin supports different renderers to display PlantUML's output. Currently,
the following renderers are implemented:

- **text** renderer: An ASCII art renderer using PlantUML's text output.
- **imv** renderer: Using the `imv` image viewer.

## Installation

Install with [packer](https://github.com/wbthomason/packer.nvim):

```lua
use { 'https://gitlab.com/itaranto/plantuml.nvim', tag = '*' }
```

## Dependencies

To use this plugin, you'll need PlantUML installed. If using the **imv** renderer, you'll need to
have [imv](https://sr.ht/~exec64/imv/) as well.

You should be able to install any of these with your system's package manager, for example, on Arch
Linux:

```sh
sudo pacman -S plantuml imv
```

## Configuration

To use the default configuration, do:

```lua
require("plantuml").setup()
```

The default values are:

```lua
local _config = {
  renderer = 'imv',
}
```

Alternatively, you can change some of the settings:

```lua
require("plantuml").setup({ renderer = 'text' })
```

## Usage

Open any file with the `.puml` extension and then write it. A new window will be
opened with the resulting diagram.

## Contributing

*"If your commit message sucks, I'm not going to accept your pull request."*
