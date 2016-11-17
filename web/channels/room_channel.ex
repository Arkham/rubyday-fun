defmodule Rubyday.RoomChannel do
  use Rubyday.Web, :channel
  alias Rubyday.VoteMap

  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    send(self, {:after_join, message})
    {:ok, socket}
  end

  def join("rooms:" <> _something_else, _msg, _socket) do
    {:error, %{reason: "Can't do this"}}
  end

  def handle_info({:after_join, _msg}, socket) do
    broadcast! socket, "user:entered", %{foo: "bar"}
    push socket, "join", %{status: "connected"}
    push socket, "updated:count", get_vote_counts()
    {:noreply, socket}
  end

  def terminate(_reason, _socket) do
    :ok
  end

  def handle_in("new:vote", vote, socket) do
    do_vote(vote)
    broadcast! socket, "updated:count", get_vote_counts()
    {:reply, {:ok, %{vote: vote}}, socket}
  end

  defp do_vote(vote) do
    VoteMap.vote(vote["choice"], vote["user_id"])
  end

  defp get_vote_counts do
    ["ruby", "elixir"]
    |> Enum.map(fn choice ->
      {choice, VoteMap.count(choice)}
    end)
    |> Enum.into(%{})
  end
end
