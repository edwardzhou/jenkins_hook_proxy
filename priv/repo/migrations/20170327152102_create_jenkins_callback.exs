defmodule JenkinsHookProxy.Repo.Migrations.CreateJenkinsHookProxy.Jenkins.Callback do
  use Ecto.Migration

  def change do
    create table(:jenkins_callbacks) do
      add :host_id, :string
      add :token, :string
      add :callback_url, :string

      timestamps()
    end

  end
end
