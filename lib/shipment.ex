defmodule Shipment do
  @validations %{
    validate_active: "Disabled shipping",
    validate_min_price: "Minimum price not reached for this method",
    validate_range_postcode: "Zip code outside the delivery area for this method"
  }

  def validations do
    @validations
  end

  def validate_methods(cep, price, methods) do
    methods
    |> Enum.map(&validate_method(cep, price, &1))
  end

  def validate_method(cep, price, %{"name" => name} = method) do
    incompatibilities = find_incompatibilities(cep, price, method)
    valid = Enum.empty?(incompatibilities)

    %{
      name: name,
      valid: valid,
      incompatibilities: incompatibilities
    }
  end

  def find_incompatibilities(cep, price, method) do
    @validations
    |> Map.keys()
    |> Enum.map(&validate_incompatibility(&1, cep, price, method))
    |> Enum.reject(&(&1 == true))
  end

  defp validate_incompatibility(validation_name, cep, price, method) do
    if apply(__MODULE__, validation_name, [cep, price, method]) do
      true
    else
      @validations[validation_name]
    end
  end

  def validate_active(_cep, _price, %{"active" => active}) do
    active
  end

  def validate_min_price(_cep, price, %{"min_price_in_cents" => min_price_in_cents}) do
    price >= min_price_in_cents
  end

  def validate_range_postcode(cep, _price, %{
        "range_postcode_valid" => [min_postcode, max_postcode | _]
      }) do
    cep >= String.to_integer(min_postcode) and cep <= String.to_integer(max_postcode)
  end
end
