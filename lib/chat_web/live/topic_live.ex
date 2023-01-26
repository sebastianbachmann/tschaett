defmodule ChatWeb.TopicLive do
  use ChatWeb, :live_view
  
  require Logger
  
  def mount(params, _session, socket) do
    Logger.info(params: params)
    
    {:ok, socket}
  end
end