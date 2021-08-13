defmodule Shipment.CliTest do
  use ExUnit.Case

  alias Shipment.Cli

  @perfect_method %{
    "name" => "Retirada em loja",
    "active" => true,
    "min_price_in_cents" => 1,
    "range_postcode_valid" => ["00000000", "99999999"]
  }

  test "parse_line/2" do
    assert false == Cli.parse_line("# some comment")
    assert false == Cli.parse_line("")
    assert false == Cli.parse_line(" ")

    assert {:cep, 1} == Cli.parse_line("CEP: 1")
    assert {:cep, 12_345_679} == Cli.parse_line("CEP: 012345679")

    assert {:price, 123} == Cli.parse_line("Preço do pedido: 123")
  end

  test "parse_lines/1 and validate_parsed/1" do
    stdin = """
    # Input
    CEP: 03108010
    Preço do pedido: 3000

    # Método analisado
    #{Jason.encode!([@perfect_method])}
    """

    parsed = Cli.parse_lines(stdin)
    assert parsed.cep == 3_108_010
    assert parsed.price == 3000
    assert parsed.methods == [@perfect_method]
    assert Cli.validate_parsed(parsed)

    stdin = """
    # Input
    """

    parsed = Cli.parse_lines(stdin)
    refute parsed[:cep]
    refute parsed[:price]
    refute parsed[:methods]
    refute Cli.validate_parsed(parsed)
  end
end
