defmodule Cinema.Timer do
  use GenServer

  def start(state \\ []) do
    GenServer.start(__MODULE__, state)
  end

  def stop(timer) do
    GenServer.stop(timer)
  end

  def init(state = [seconds: seconds, callback: _callback]) do
    Process.send_after(self(), :action, seconds * 1000)

    {:ok, state}
  end

  def handle_info(:action, state = [seconds: _seconds, callback: callback]) do
    callback.()

    {:stop, :normal, state}
  end
end
