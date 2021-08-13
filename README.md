# Shipment CLI

Validate CEP (brazilian postal code) CLI

## Installation

Clone this repo then run, install dependencies then run `mix`

See below.

## Build

Enter the cloned repo folder then:

```
mix deps.get
mix #=> aliased mix.escript_build
```

## Usage

```
$ mix # build before using at least once
$ cat priv/fixtures/basic.txt | ./shipment
```

## Implementation commentary

For this project there are two main modules: `Shipment` and `Shipment.Cli`. `Shipment` will handle validation rules and it has a neat way to add new rules. `Shipment.Cli` is responsible for understanding the outside world to run `Shipment`. Noteworthy to say that `Shipment.Cli` is the target os our `escript` build.

The sole external dependency is [Jason](https://hexdocs.pm/jason/readme.html) so we can have a realible JSON parser that can pretty print final results and be fault tolerant. Chosen since it has been the main module being used by big projects such as Ecto and Absinthe and is battle tested.

Elixir ❤️ loves metaprogramming so the `Shipment` module uses metaprogramming to make easy to add new validations rules. A developer would only need to add a new key-value pair [at the top](https://github.com/lubien/shipment/blob/master/lib/shipment.ex#L2) then actually implement the function named on the key as a ternary function that receives `CEP`, `Price`, and `Method` (a single method) like the [3 current ones](https://github.com/lubien/shipment/blob/master/lib/shipment.ex#L43-L55). Don't forget to test 🙂.

## License

[MIT](LICENSE.md)