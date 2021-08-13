defmodule ShipmentTest do
  use ExUnit.Case
  doctest Shipment

  @perfect_method %{
    "name" => "Retirada em loja",
    "active" => true,
    "min_price_in_cents" => 1,
    "range_postcode_valid" => ["00000000", "99999999"]
  }

  @inactive_method %{
    "name" => "Retirada em loja",
    "active" => false,
    "min_price_in_cents" => 1,
    "range_postcode_valid" => ["00000000", "99999999"]
  }

  @expensive_method %{
    "name" => "Retirada em loja",
    "active" => true,
    "min_price_in_cents" => 1_000_000,
    "range_postcode_valid" => ["00000000", "99999999"]
  }

  @exclusive_range_method %{
    "name" => "Retirada em loja",
    "active" => true,
    "min_price_in_cents" => 1,
    "range_postcode_valid" => ["99999999", "99999999"]
  }

  @worst_method %{
    "name" => "Retirada em loja",
    "active" => false,
    "min_price_in_cents" => 1_000_000,
    "range_postcode_valid" => ["99999999", "99999999"]
  }

  test "validate_method/3" do
    validations = Shipment.validations()

    cep = 03_108_010
    price = 3000

    assert %{name: @perfect_method["name"], valid: true, incompatibilities: []} ==
             Shipment.validate_method(cep, price, @perfect_method)

    assert %{
             name: @inactive_method["name"],
             valid: false,
             incompatibilities: [validations.validate_active]
           } == Shipment.validate_method(cep, price, @inactive_method)

    assert %{
             name: @expensive_method["name"],
             valid: false,
             incompatibilities: [validations.validate_min_price]
           } == Shipment.validate_method(cep, price, @expensive_method)

    assert %{
             name: @exclusive_range_method["name"],
             valid: false,
             incompatibilities: [validations.validate_range_postcode]
           } == Shipment.validate_method(cep, price, @exclusive_range_method)

    assert %{
             name: @worst_method["name"],
             valid: false,
             incompatibilities: Map.values(validations)
           } == Shipment.validate_method(cep, price, @worst_method)
  end

  test "find_incompatibilities/3" do
    validations = Shipment.validations()

    cep = 03_108_010
    price = 3000

    assert [] == Shipment.find_incompatibilities(cep, price, @perfect_method)

    assert [validations.validate_active] ==
             Shipment.find_incompatibilities(cep, price, @inactive_method)

    assert [validations.validate_min_price] ==
             Shipment.find_incompatibilities(cep, price, @expensive_method)

    assert [validations.validate_range_postcode] ==
             Shipment.find_incompatibilities(cep, price, @exclusive_range_method)

    assert Map.values(validations) == Shipment.find_incompatibilities(cep, price, @worst_method)
  end

  test "validate_active/3" do
    cep = 03_108_010
    price = 3000

    assert Shipment.validate_active(cep, price, @perfect_method)
    refute Shipment.validate_active(cep, price, @inactive_method)
  end

  test "validate_min_price/3" do
    cep = 03_108_010
    price = 3000

    assert Shipment.validate_min_price(cep, price, @perfect_method)
    refute Shipment.validate_min_price(cep, price, @expensive_method)
  end

  test "validate_range_postcode/3" do
    cep = 03_108_010
    price = 3000

    assert Shipment.validate_range_postcode(cep, price, @perfect_method)
    refute Shipment.validate_range_postcode(cep, price, @exclusive_range_method)
  end
end
