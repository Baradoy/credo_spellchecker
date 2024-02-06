defmodule CredoSpellchecker.DictionaryServer do
  use GenServer, restart: :transient

  @moduledoc """
  A GenServer to cache dictionaries from DictionaryReader

  get_dictionaries(params) will start the GenServer if it is not already started.
  """

  def start_link(params),
    do: GenServer.start_link(__MODULE__, params, name: __MODULE__)

  def get_dictionaries(params) do
    {:ok, pid} =
      params
      |> ensure_started()
      |> extract_pid()

    GenServer.call(pid, :get_dictionaries)
  end

  def init(params), do: {:ok, %{params: params, dictionaries: nil}}

  def handle_call(:get_dictionaries, _from, %{params: params, dictionaries: nil}) do
    dictionaries = CredoSpellchecker.DictionaryReader.dictionaries(params)

    {:reply, dictionaries, %{params: params, dictionaries: dictionaries}}
  end

  def handle_call(:get_dictionaries, _from, %{dictionaries: dictionaries}) do
    {:reply, dictionaries, %{dictionaries: dictionaries}}
  end

  defp ensure_started(params) do
    __MODULE__
    |> Process.whereis()
    |> case do
      nil -> start_link(params)
      pid -> {:ok, pid}
    end
  end

  defp extract_pid({:ok, pid}) do
    {:ok, pid}
  end

  defp extract_pid({:error, {:already_started, pid}}) do
    {:ok, pid}
  end
end
