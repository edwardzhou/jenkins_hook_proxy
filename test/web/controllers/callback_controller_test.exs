defmodule JenkinsHookProxy.Web.CallbackControllerTest do
  use JenkinsHookProxy.Web.ConnCase

  alias JenkinsHookProxy.Jenkins
  alias JenkinsHookProxy.Jenkins.Callback

  @create_attrs %{callback_url: "some callback_url", host_id: "some host_id", token: "some token"}
  @update_attrs %{callback_url: "some updated callback_url", host_id: "some updated host_id", token: "some updated token"}
  @invalid_attrs %{callback_url: nil, host_id: nil, token: nil}

  def fixture(:callback) do
    {:ok, callback} = Jenkins.create_callback(@create_attrs)
    callback
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, callback_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates callback and renders callback when data is valid", %{conn: conn} do
    conn = post conn, callback_path(conn, :create), callback: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, callback_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "callback_url" => "some callback_url",
      "host_id" => "some host_id",
      "token" => "some token"}
  end

  test "does not create callback and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, callback_path(conn, :create), callback: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen callback and renders callback when data is valid", %{conn: conn} do
    %Callback{id: id} = callback = fixture(:callback)
    conn = put conn, callback_path(conn, :update, callback), callback: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, callback_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "callback_url" => "some updated callback_url",
      "host_id" => "some updated host_id",
      "token" => "some updated token"}
  end

  test "does not update chosen callback and renders errors when data is invalid", %{conn: conn} do
    callback = fixture(:callback)
    conn = put conn, callback_path(conn, :update, callback), callback: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen callback", %{conn: conn} do
    callback = fixture(:callback)
    conn = delete conn, callback_path(conn, :delete, callback)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, callback_path(conn, :show, callback)
    end
  end
end
