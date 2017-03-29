defmodule JenkinsHookProxy.Web.CallbackController do
  use JenkinsHookProxy.Web, :controller

  alias JenkinsHookProxy.Jenkins
  alias JenkinsHookProxy.Jenkins.Callback

  action_fallback JenkinsHookProxy.Web.FallbackController

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
            raw_headers: conn.req_headers |> Enum.into(%{}),
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
    end
  end
end
