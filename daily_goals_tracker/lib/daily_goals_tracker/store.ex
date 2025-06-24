defmodule DailyGoalsTracker.Store do
  use GenServer
  require Logger

  defstruct goals: [],
            achievements: []

  def start_link(opts \\ []) do
    {start_opts, store_opts} =
      opts
      |> Keyword.put_new(:name, __MODULE__)
      |> Keyword.split([:debug, :name, :timeout, :spawn_opt, :hibernate_after])

    seed = Keyword.get(store_opts, :seed, %{})

    state = %__MODULE__{
      goals: seed[:goals] || [],
      achievements: seed[:progress] || []
    }

    GenServer.start_link(__MODULE__, state, start_opts)
  end

  def list(key, opts \\ []) when is_atom(key) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.call(name, {:list, key})
  end

  def list_by(by, key, opts \\ []) when is_map(by) and is_atom(key) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.call(name, {:list, key, by})
  end

  def get(id, key, opts \\ []) when is_atom(key) and is_integer(id) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.call(name, {:get, key, id})
  end

  def create(entity, key, opts \\ []) when is_atom(key) and is_map(entity) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.call(name, {:create, key, entity})
  end

  def update(entity, key, opts \\ []) when is_atom(key) and is_map(entity) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.call(name, {:update, key, entity})
  end

  def delete(entity, key, opts \\ []) when is_atom(key) and is_map(entity) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.call(name, {:delete, key, entity})
  end

  def clear(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.call(name, :clear)
  end

  @impl GenServer
  def init(%__MODULE__{} = state) do
    {:ok, state}
  end

  @impl GenServer
  def handle_call({:list, key, by}, _from, %__MODULE__{} = state) do
    entities = Map.get(state, key, [])

    selected_entities =
      Enum.filter(entities, fn entity ->
        Enum.all?(by, fn {field, value} -> Map.get(entity, field) == value end)
      end)

    {:reply, selected_entities, state}
  end

  def handle_call({:list, key}, _from, %__MODULE__{} = state) do
    entities = Map.get(state, key, [])
    {:reply, entities, state}
  end

  def handle_call({:create, key, entity}, _from, %__MODULE__{} = state) do
    entities = Map.get(state, key, [])
    new_entity = Map.merge(entity, %{id: next_id(state, key), inserted_at: DateTime.utc_now()})
    new_state = Map.put(state, key, [new_entity | entities])
    {:reply, {:ok, new_entity}, new_state}
  end

  def handle_call({:get, key, id}, _from, %__MODULE__{} = state) do
    entities = Map.get(state, key, [])
    entity = Enum.find(entities, &(&1.id == id))
    {:reply, entity, state}
  end

  def handle_call({:update, key, new_entity}, _from, %__MODULE__{} = state) do
    entities = Map.get(state, key, [])

    new_entities =
      Enum.reduce(entities, [], fn entity, acc ->
        if entity.id == new_entity.id do
          [new_entity | acc]
        else
          [entity | acc]
        end
      end)

    new_state = Map.put(state, key, new_entities)
    {:reply, {:ok, new_entity}, new_state}
  end

  def handle_call({:delete, key, entity}, _from, %__MODULE__{} = state) do
    entities = Map.get(state, key, [])
    new_entities = List.delete(entities, entity)
    new_state = Map.put(state, key, new_entities)
    {:reply, {:ok, entity}, new_state}
  end

  def handle_call(:clear, _from, %__MODULE__{} = _state) do
    {:reply, :ok, %__MODULE__{}}
  end

  defp next_id(state, key) do
    case Map.get(state, key, []) do
      nil -> 1
      [] -> 1
      entities -> Enum.max_by(entities, &Map.get(&1, :id)).id + 1
    end
  end
end
