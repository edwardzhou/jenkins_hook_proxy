defmodule JenkinsHookProxy.Web.CallbackController do
  use JenkinsHookProxy.Web, :controller

  alias JenkinsHookProxy.Jenkins
  alias JenkinsHookProxy.Jenkins.Callback

  action_fallback JenkinsHookProxy.Web.FallbackController

#  def index(conn, _params) do
#    callbacks = Jenkins.list_callbacks()
#    render(conn, "index.json", callbacks: callbacks)
#  end

  def create(conn, %{"host_id" => host_id, "token" => token} = params) do
#    host_id = Map.get(params, "host_id")
    IO.puts "host_id: #{host_id}, token: #{token}"
    with %Callback{} = callback <- Jenkins.get_callback_by_host_id!(host_id) do
      case callback.token do
        ^token ->

          payload = %{
            github_headers: %{
              "User-Agent": conn |> get_req_header("user-agent") |> List.first,
              "X-GitHub-Delivery": conn |> get_req_header("x-github-delivery") |> List.first,
              "X-GitHub-Event": conn |> get_req_header("x-github-event") |> List.first
            },
            jenkins: %{
              "callback_url": callback.callback_url
            },
            body: params |> Map.delete("token") |> Map.delete("host_id")
          }

          JenkinsHookProxy.Web.Endpoint.broadcast! "jenkins:lobby", "jenkins_msg", payload

           conn
           |> json(%{result: "ok"})
       _ ->
          conn
          |> put_status(:forbidden)
          |> json(%{error: "token not matched."})
      end
#      |> put_status(:created)
#      |> put_resp_header("location", callback_path(conn, :show, callback))
#      |> render("show.json", callback: callback)
    end
  end
#
#  def show(conn, %{"id" => id}) do
#    callback = Jenkins.get_callback!(id)
#    render(conn, "show.json", callback: callback)
#  end
#
#  def update(conn, %{"id" => id, "callback" => callback_params}) do
#    callback = Jenkins.get_callback!(id)
#
#    with {:ok, %Callback{} = callback} <- Jenkins.update_callback(callback, callback_params) do
#      render(conn, "show.json", callback: callback)
#    end
#  end
#
#  def delete(conn, %{"id" => id}) do
#    callback = Jenkins.get_callback!(id)
#    with {:ok, %Callback{}} <- Jenkins.delete_callback(callback) do
#      send_resp(conn, :no_content, "")
#    end
#  end
end
