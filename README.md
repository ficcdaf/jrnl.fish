# jrnl.fish

> Fishy journaling 🐟
>
> Part of my [utilities](https://sr.ht/~ficd/utils/) collection.

`jrnl` is a simple Fish utility for journaling in Markdown. It creates daily
journal entries based on a template. The `jrnl` command opens today's entry in
your `$EDITOR`, making it easy to journal from any terminal!

- [Usage](#usage)
  - [Template](#template)
- [Installation](#installation)
- [Acknowledgements](#acknowledgements)
- [Contributing](#contributing)
- [License](#license)

## Usage

To get started, simply run `jrnl`. You'll be prompted to edit and save the
default template if one doesn't already exist.

To open today's entry, creating it if it doesn't yet exist:

```fish
jrnl
```

To edit the template at any time:

```fish
jrnl -e
jrnl --edit-template
```

To set the journal directory (`~/jrnl` by default):

```fish
# via an environment variable called jrnl_directory
set -Ug jrnl_directory /path/to/journal
# or via command option
jrnl -d=path/to/journal
jrnl --dir=path/to/journal
```

To set the template file (relative to the journal directory, `template.md` by
default):

```fish
# via an environment variable called jrnl_template
set -Ug jrnl_template template_name.md
# or via command option
jrnl -t=template_name.md
jrnl --template=template_name.md
```

To show the help menu:

```fish
jrnl -h
jrnl --help
```

### Template

`jrnl.fish` implements a very basic template system. The template file should be
a Markdown file inside the journal directory. Markdown comments are skipped, and
extra newlines at the end of the file are trimmed.

The following literals are substituted:

- `%{date}`
  - Short date: `2025-04-23`.
- `%{date_long}`
  - Long date: `Wednesday, Apr 23, 2025`.

## Installation

To install directly, you can download [jrnl.fish](./functions/jrnl.fish) and
place it inside your `$fish_config/functions`:

```fish
curl https://git.sr.ht/~ficd/jrnl.fish/blob/mail/jrnl.fish \
    -o $fish_config/functions/jrnl.fish
```

You can also use Fisher to install from the GitHub mirror:

```fish
fisher install ficcdaf/jrnl.fish
```

## Acknowledgements

- Will Munslow's original [jrnl](https://github.com/subterrane/jrnl) script.

## Contributing

Please submit patches, questions, and discussion points to the
[mailing list](https://lists.sr.ht/~ficd/utils), and make bug reports and
feature requests on the [ticket tracker](https://todo.sr.ht/~ficd/utils).

## License

[MIT](./LICENSE)
