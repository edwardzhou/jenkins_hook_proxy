defmodule JenkinsHookProxy.Jenkins.Callback do
  use Ecto.Schema

  schema "jenkins_callbacks" do
    field :callback_url, :string
    field :host_id, :string
    field :token, :string

    timestamps()
  end

end
