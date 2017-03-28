defmodule JenkinsHookProxy.JenkinsTest do
  use JenkinsHookProxy.DataCase

  alias JenkinsHookProxy.Jenkins
  alias JenkinsHookProxy.Jenkins.Callback

  @create_attrs %{callback_url: "some callback_url", host_id: "some host_id", token: "some token"}
  @update_attrs %{callback_url: "some updated callback_url", host_id: "some updated host_id", token: "some updated token"}
  @invalid_attrs %{callback_url: nil, host_id: nil, token: nil}

  def fixture(:callback, attrs \\ @create_attrs) do
    {:ok, callback} = Jenkins.create_callback(attrs)
    callback
  end

  test "list_callbacks/1 returns all callbacks" do
    callback = fixture(:callback)
    assert Jenkins.list_callbacks() == [callback]
  end

  test "get_callback! returns the callback with given id" do
    callback = fixture(:callback)
    assert Jenkins.get_callback!(callback.id) == callback
  end

  test "create_callback/1 with valid data creates a callback" do
    assert {:ok, %Callback{} = callback} = Jenkins.create_callback(@create_attrs)
    assert callback.callback_url == "some callback_url"
    assert callback.host_id == "some host_id"
    assert callback.token == "some token"
  end

  test "create_callback/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Jenkins.create_callback(@invalid_attrs)
  end

  test "update_callback/2 with valid data updates the callback" do
    callback = fixture(:callback)
    assert {:ok, callback} = Jenkins.update_callback(callback, @update_attrs)
    assert %Callback{} = callback
    assert callback.callback_url == "some updated callback_url"
    assert callback.host_id == "some updated host_id"
    assert callback.token == "some updated token"
  end

  test "update_callback/2 with invalid data returns error changeset" do
    callback = fixture(:callback)
    assert {:error, %Ecto.Changeset{}} = Jenkins.update_callback(callback, @invalid_attrs)
    assert callback == Jenkins.get_callback!(callback.id)
  end

  test "delete_callback/1 deletes the callback" do
    callback = fixture(:callback)
    assert {:ok, %Callback{}} = Jenkins.delete_callback(callback)
    assert_raise Ecto.NoResultsError, fn -> Jenkins.get_callback!(callback.id) end
  end

  test "change_callback/1 returns a callback changeset" do
    callback = fixture(:callback)
    assert %Ecto.Changeset{} = Jenkins.change_callback(callback)
  end
end
