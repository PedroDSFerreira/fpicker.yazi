# fpicker.yazi
Yazi plugin to pick a folder in a directory, using fzf. This is useful for opening mounted devices (demo video), or a project folder in a workspace, for example.


## Requirements

- fzf

## Installation

```sh
ya pack -a PedroDSFerreira/fpicker.yazi
```

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = ["f", "u"]
run  = "plugin fpicker --args='<dir-path>'"
desc = "Pick a folder"
```

Make sure the <kbd>fu</kbd> keymap is not used elsewhere.

## License

This plugin is MIT-licensed. For more information check the [LICENSE](LICENSE) file.
