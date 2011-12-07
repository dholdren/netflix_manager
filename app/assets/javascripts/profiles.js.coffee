# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


#$('.queue').droppable();
#$('.queue_item').draggable({
#  drop: function( event, ui ) {
#(($)-> 
#    drop: (event, ui)  ->
#)(jQuery)

#$('.queue').droppable()
#$('.queue_item').draggable()

#$('.queue').droppable()
#$('.queue_item').draggable()

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
      #alert("sender_id: "+sender_id);
      #alert("sender_etag: "+sender_etag);
      #alert("ui.position: "+ui.position);
      #alert("item position: "+position);
      #alert("item: "+item_id);
      #alert("receiver_id: "+receiver_id);
      #alert("receiver_etag: "+receiver_etag);
      $.post("/movie_queues/move", "from=#{sender_id}&from_etag=#{sender_etag}&to=#{receiver_id}&to_etag=#{receiver_etag}&item=#{item_id}&position=#{position}")
  .disableSelection()

