defmodule JenkinsHookProxy.Web.CallbackView do
  use JenkinsHookProxy.Web, :view
  alias JenkinsHookProxy.Web.CallbackView

  def render("index.json", %{callbacks: callbacks}) do
    %{data: render_many(callbacks, CallbackView, "callback.json")}
  end

  def render("show.json", %{callback: callback}) do
    %{data: render_one(callback, CallbackView, "callback.json")}
  end

  def render("callback.json", %{callback: callback}) do
    %{id: callback.id,
      host_id: callback.host_id,
      token: callback.token,
      callback_url: callback.callback_url}
  end
end
