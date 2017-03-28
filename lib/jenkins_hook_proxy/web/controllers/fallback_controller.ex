defmodule JenkinsHookProxy.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use JenkinsHookProxy.Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(JenkinsHookProxy.Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(JenkinsHookProxy.Web.ErrorView, :"404")
  end

  def call(conn, {:error, %Ecto.NoResultsError{} = _error}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Jenkins not found"})
  end

end
