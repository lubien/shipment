# Shipment CLI

Validate CEP (brazilian postal code) CLI

## Installation

`mix escript.install github lubien/shipment`

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

## License

[MIT](LICENSE.md)