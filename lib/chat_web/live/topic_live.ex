defmodule ChatWeb.TopicLive do
  use ChatWeb, :live_view

  require Logger

  def mount(params = %{"topic_name" => topic_name}, _session, socket) do
    Logger.info(params: params)

    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(topic_name)
    end

    username = AnonymousNameGenerator.generate_random()

    {:ok,
     assign(socket,
       topic_name: topic_name,
       username: username,
       message: "",
       chat_messages: [],
       temporary_assigns: [chat_messages: []]
     )}
  end

  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    message_data = %{
      msg: message,
      username: socket.assigns.username,
      uuid: AnonymousNameGenerator.generate_random()
    }

    ChatWeb.Endpoint.broadcast(socket.assigns.topic_name, "new_message", message_data)

    {:noreply, assign(socket, message: "")}
  end

  def handle_event("message_change", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  def handle_info(%{event: "new_message", payload: message_data}, socket) do
    Logger.info(chat_messages: socket.assigns.chat_messages)

    {:noreply, assign(socket, chat_messages: [message_data])}
  end

  def user_msg_heex(assigns = %{msg_data: %{msg: msg, username: username, uuid: uuid}}) do
    ~H"""
    <li
      id={uuid}
      class="relative bg-white py-5 px-4 focus-within:ring-2 focus-within:ring-inset focus-within:ring-indigo-600 hover:bg-gray-50"
    >
      <div class="flex justify-between space-x-3">
        <div class="min-w-0 flex-1">
          <a href="#" class="block focus:outline-none">
            <span class="absolute inset-0" aria-hidden="true"></span>
            <p class="truncate text-sm font-medium text-gray-900 mb-4"><%= username %></p>
          </a>
        </div>
      </div>
      <div class="mt-1">
        <p class="text-sm text-gray-600 line-clamp-2"><%= msg %></p>
      </div>
    </li>
    """
  end
end
