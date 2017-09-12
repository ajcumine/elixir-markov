
## Elixir Markov Chain Exercise

This is a basic text generator using a Markov chain algorithm. It is very simple and not intended to be used in any kind of environment, only as an experiment and learning tool for myself.

### Requirements
Built and tested with Elixir v1.5.1.

### Usage
To run the text generator, from the project home directory:
```bash
$: iex -S mix
```
This will load the interactive elixir environment with the project included. Within this environment there are 2 options:
```elixir
iex> Markov.generate_text(body, order, max_length)
```
```elixir
iex> Markov.generate_text_with_word(body, initial)
```

Body:
This is the text that the chain is generated from, it must be a string.

Order:
This is the number of words used to generate the values for each key of the Markov chain. This defaults to 1.

Max Length:
This is the maximum number of characters that the generated text will reach. This defaults to 140 characters.

Initial:
This is the word that will be used as the starting point for any string generated, if it is chosen poorly the generated string will be small.

Using `Markov.generate_text/1-3` will set use an initial of the first word of the body string.

Using `Markov.generate_text_with_word/2` will use the default values for `order` and `max_length`.

### Testing
To run the tests, from the project home directory:
```bash
$: mix test
```

### Tips for use
The greater your source text the more options of initial values you will have available and the more variance there will be in your generated text. 1st order chains allow for more variance in generated text but will give less readability. The higher the order used the more readable but the less variance the generated text will have.

### Possible further improvements
* Improve performance and refactor.
* Read source text from a file.
* Create a simple CLI for easy usage.
* Build a fancy front-end UI and host this somewhere ¯\\_(ツ)_/¯

### License
MIT
