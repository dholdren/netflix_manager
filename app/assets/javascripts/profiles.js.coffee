# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $( ".queue" ).sortable
    connectWith: ".queueConnect"
    receive: (event, ui) -> 
      sender_id = $(ui.sender).attr("id")
      sender_etag = $(ui.sender).attr("etag")
      receiver_id = $(this).attr("id")
      receiver_etag = $(this).attr("etag")
      item_id = $(ui.item).attr("id")
      position = ui.item.index()
      $.post "/movie_queues/move", "from=#{sender_id}&from_etag=#{sender_etag}&to=#{receiver_id}&to_etag=#{receiver_etag}&item=#{item_id}&position=#{position}", (data) -> refresh_profiles(data)
  .disableSelection()

refresh_profiles = (data) ->
  alert("in refresh_profiles")
  $.each data, (profile) ->
    #1) reset etag on <ul class="queue queueConnect" id="queue_<%= queue.id %>" etag="<%=queue.etag%>">
    $("ul#queue_#{profile.disc_queue.id}").etag = profile.disc_queue.etag
    #2) remove li's
    $("ul#queue_#{profile.disc_queue.id} li").remove
    #3) add li's <li class="ui-state-default queue_item" id="queue_item_<%= disc.id %>"><%= disc.title %></li>
    $ "<li/>"
      'class': "ui-state-default queue_item"
      id: "queue_item_#{disc.id}"
      html: disc.title
    .appendTo("ul#queue_#{profile.disc_queue.id}")
