defmodule Shipment.Cli do
  def main(_argv) do
    read_stdin_and_run()
  end

  def read_stdin_and_run do
    IO.read(:stdio, :all)
    |> run()
  end

  def run(stdin) do
    stdin
    |> parse_lines()
    |> continue_if_valid()
  end

  def continue_if_valid(parsed) do
    if validate_parsed(parsed) do
      parsed
      |> do_validate()
      |> Jason.encode!(pretty: true)
      |> IO.puts()
    else
      IO.puts("Invalid stdin")
      System.stop(1)
    end
  end

  def do_validate(config) do
    Shipment.validate_methods(config.cep, config.price, config.methods)
  end

  def parse_lines(stdin) do
    {regular_lines, json_parts} =
      stdin
      |> String.split("\n")
      |> Enum.split_while(fn line ->
        first_char =
          line
          |> String.trim()
          |> String.at(0)

        first_char != "["
      end)

    methods =
      case Jason.decode(json_parts) do
        {:ok, parsed} ->
          parsed

        _ ->
          nil
      end

    regular_lines
    |> Enum.reduce(%{}, fn line, acc ->
      case parse_line(line) do
        {key, value} ->
          Map.put_new(acc, key, value)

        _ ->
          acc
      end
    end)
    |> Map.put(:methods, methods)
  end

  def validate_parsed(parsed) do
    is_number(parsed[:cep]) and
      is_number(parsed[:price]) and
      is_list(parsed[:methods]) and
      Enum.all?(parsed[:methods], fn method ->
        is_binary(method["name"]) and
          is_number(method["min_price_in_cents"]) and
          is_boolean(method["active"]) and
          is_list(method["range_postcode_valid"]) and
          is_binary(Enum.at(method["range_postcode_valid"], 0)) and
          is_binary(Enum.at(method["range_postcode_valid"], 1))
      end)
  end

  def parse_line("CEP:" <> cep) do
    {:cep, parse_integer(cep)}
  end

  def parse_line("Preço do pedido:" <> price) do
    {:price, parse_integer(price)}
  end

  def parse_line(_line), do: false

  defp parse_integer(string) do
    string
    |> String.trim()
    |> String.to_integer()
  end
end
