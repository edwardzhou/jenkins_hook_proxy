defmodule JenkinsHookProxy.Web.CallbackController do
  use JenkinsHookProxy.Web, :controller

  alias JenkinsHookProxy.Jenkins
  alias JenkinsHookProxy.Jenkins.Callback

  action_fallback JenkinsHookProxy.Web.FallbackController

  def create(conn, %{"host_id" => host_id, "token" => token} = params) do
    with %Callback{} = callback <- Jenkins.get_callback_by_host_id!(host_id) do
      case callback.token do
        ^token ->
          # token与数据库的token匹配
          payload = %{
            # 提取github请求头(x- 开头 和 user-agent), 用于内网转发
            github_headers: conn.req_headers
                            |> Enum.filter(fn({k, v}) -> to_string(k) |> String.starts_with?(["x-", "user-agent"]) end)
                            |> Enum.into(%{}),
            jenkins: %{
              # 内网Jenkins Hook地址
              "callback_url": callback.callback_url
            },
            # 原生请求头, 无实际用途，方便调试查看用
            raw_headers: conn.req_headers |> Enum.into(%{}),
            # github请求参数，剔除 host_id 与 token
            body: params |> Map.drop(["token", "host_id"])
          }
          # websocket广播，向通道 jenkins:lobby 回传 jenkins_msg 事件
          JenkinsHookProxy.Web.Endpoint.broadcast! "jenkins:lobby", "jenkins_msg", payload

          # 返回正常给github
          conn
          |> json(%{result: "ok"})

       _ ->
        # token无效，返回403给github
        conn
        |> put_status(:forbidden)
        |> json(%{error: "token not matched."})
      end
    end
  end
end
