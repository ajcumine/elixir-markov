
# Elixir Markov Chain Exercise

This is a basic text generator using a Markov chain algorithm. It is very simple and not intended to be used in any kind of environment, only as an experiment and learning tool for myself.

## Requirements
Built and tested with [Elixir](https://elixir-lang.org/) v1.5.1.

Static code analysis with [Credo](https://github.com/rrrene/credo).

## Usage
To install dependencies, from the project home directory:
```bash
$: mix deps.get
```
To run the text generator, from the project home directory:
```bash
$: iex -S mix
```
This will load the interactive elixir environment with the project included. Within this environment there are 2 options:
```elixir
iex> Markov.generate_text(source_text, order, max_length, focus)
```
```elixir
iex> Markov.generate_text_with_word(source_text, focus)
```

Body:
This is the text that the chain is generated from, it must be a string.

Order:
This is the number of words used to generate the values for each key of the Markov chain. This defaults to 1.

Max Length:
This is the maximum number of characters that the generated text will reach. This defaults to 140 characters.

Focus:
This is the word that will be used as the starting point for any string generated, if it is chosen poorly the generated string will be small. This must have the same number of words as the `order`. If this is not provided a random focus will be picked based on the `order` and `source_text`

Using `Markov.generate_text/1-4` allows you to provide the `order`, `max_length`, and `focus` or use their default values.

Using `Markov.generate_text_with_word/2` will use the default values for `order` and `max_length`, and provide a random `focus` based on the `source_text` provided.

## Testing
To run the tests, from the project home directory:
```bash
$: mix test
```

To run the static code analysis tool, ([Credo](https://github.com/rrrene/credo)):
```bash
$: mix credo
```

## Tips for use
The greater your source text the more options of initial values you will have available and the more variance there will be in your generated text. 1st order chains allow for more variance in generated text but will give less readability. The higher the order used the more readable but the less variance the generated text will have.

## Possible further improvements
* Read source text from a file.
* Create a simple CLI for easy usage.
* Build a fancy front-end UI and host this somewhere ¯\\_(ツ)_/¯

## License
MIT
