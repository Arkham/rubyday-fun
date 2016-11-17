defmodule Rubyday.VoteMap do
  def create_table do
    :ets.new(__MODULE__, [:bag, :public, :named_table])
  end

  def vote(choice, user_id) do
    case :ets.match(__MODULE__, {:"$1", user_id}) do
      [] -> :ets.insert(__MODULE__, {choice, user_id})
      _match -> true
    end
  end

  def count(choice) do
    Enum.count(:ets.lookup(__MODULE__, choice))
  end
end
