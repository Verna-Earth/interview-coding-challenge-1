defmodule Bullet.Utils do
  def key_to_atom(map) do
    Enum.reduce(map, %{}, fn
      # String.to_existing_atom saves us from overloading the VM by
      # creating too many atoms. It'll always succeed because all the fields
      # in the database already exist as atoms at runtime.
      {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
      {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
    end)
  end

  @doc """
  Returns the percentage in string, eg 5%, 10%, 100%
  We will only return 100% as the max, even when value is larger than base 
  """
  def get_percentage_string(value, base) when is_integer(base) and is_integer(value) do
    cond do
      value >= base -> "100%"
      true -> Number.Percentage.number_to_percentage(value / base * 100, precision: 0)
    end
  end
end
