defmodule ChatWeb.TopicLive do
  use ChatWeb, :live_view

  require Logger

  def mount(params = %{"topic_name" => topic_name}, _session, socket) do
    Logger.info(params: params)

    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic_name)
    end

    username = AnonymousNameGenerator.generate_random()

    {:ok, assign(socket, topic_name: topic_name, username: username, message: "")}
  end

  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    Logger.info(submit_message: message)

    ChatWeb.Endpoint.broadcast(socket.assigns.topic_name, "new_message", message)

    {:noreply, assign(socket, message: "")}
  end

  def handle_event("message_change", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  def handle_info(%{event: "new_message", payload: message_data}, socket) do
    Logger.info(message_data: message_data)
    {:noreply, socket}
  end
end
