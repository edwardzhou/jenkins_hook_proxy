defmodule JenkinsHookProxy.Jenkins do
  @moduledoc """
  The boundary for the Jenkins system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias JenkinsHookProxy.Repo

  alias JenkinsHookProxy.Jenkins.Callback

  @doc """
  Returns the list of callbacks.

  ## Examples

      iex> list_callbacks()
      [%Callback{}, ...]

  """
  def list_callbacks do
    Repo.all(Callback)
  end

  @doc """
  Gets a single callback.

  Raises `Ecto.NoResultsError` if the Callback does not exist.

  ## Examples

      iex> get_callback!(123)
      %Callback{}

      iex> get_callback!(456)
      ** (Ecto.NoResultsError)

  """
  def get_callback!(id), do: Repo.get!(Callback, id)

  @doc """
  Gets a single callback by host_id.

  Raises `Ecto.NoResultsError` if the Callback does not exists.

  """
  def get_callback_by_host_id!(host_id), do: Repo.get_by!(Callback, host_id: host_id)


  @doc """
  Creates a callback.

  ## Examples

      iex> create_callback(%{field: value})
      {:ok, %Callback{}}

      iex> create_callback(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_callback(attrs \\ %{}) do
    %Callback{}
    |> callback_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a callback.

  ## Examples

      iex> update_callback(callback, %{field: new_value})
      {:ok, %Callback{}}

      iex> update_callback(callback, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_callback(%Callback{} = callback, attrs) do
    callback
    |> callback_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Callback.

  ## Examples

      iex> delete_callback(callback)
      {:ok, %Callback{}}

      iex> delete_callback(callback)
      {:error, %Ecto.Changeset{}}

  """
  def delete_callback(%Callback{} = callback) do
    Repo.delete(callback)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking callback changes.

  ## Examples

      iex> change_callback(callback)
      %Ecto.Changeset{source: %Callback{}}

  """
  def change_callback(%Callback{} = callback) do
    callback_changeset(callback, %{})
  end

  defp callback_changeset(%Callback{} = callback, attrs) do
    callback
    |> cast(attrs, [:host_id, :token, :callback_url])
    |> validate_required([:host_id, :token, :callback_url])
  end
end
