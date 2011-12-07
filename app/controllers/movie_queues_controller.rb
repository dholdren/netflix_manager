class MovieQueuesController < ApplicationController
    before_filter :authenticate_user!  
  
  def move
    item = params["item"]
    from_queue_id = params["from"]
    from_etag = params["from_etag"]
    to_queue_id = params["to"]
    to_etag = params["to_etag"]
    position = params["position"]
    logger.debug "[#{self.class.name}#move]: item #{item}, from #{from_queue_id}, to #{to_queue_id}, from_etag #{from_etag}, to_etag #{to_etag}, position #{position}"
    
    @from_queue = MovieQueue.get_disc_queue_by_id(current_user, from_queue_id)
    @to_queue = MovieQueue.get_disc_queue_by_id(current_user, to_queue_id)
    
    #TODO: only delete if successfully added to other queue
    #if add_to_queue(@to_queue, to_etag, item, (position.to_i + 1))
    add_to_queue(@to_queue, to_etag, item, (position.to_i + 1))
    delete_from_queue(@from_queue, from_etag, item)
    #else
    #end
    #else
    #  "error adding"
    #end
    head :ok
  end
  
  private
  def add_to_queue(queue, queue_etag, item, position)
    title_ref = extract_title_ref(item)
    logger.debug "[#{self.class.name}#add_to_queue]: title_ref #{title_ref}, position #{position}"
    queue.add(title_ref, position, queue_etag)
  end
  
  def delete_from_queue(queue, queue_etag, item)
    item_id = extract_queue_item_id(item)
    logger.debug "[#{self.class.name}#delete_from_queue]: item_id #{item_id}"
    queue.remove(item_id, queue_etag)
  end
  
  def extract_queue_url(queue)
    logger.debug "[#{self.class.name}#extract_queue_url] queue=#{queue}"
    queue =~ /queue_(.*)\/available/
    url = "/users/#{URI.unescape($1)}"
  end
  
  def extract_queue_item_id(item)
    item =~ /queue_item_(.*)/
    $1
  end
  
  def extract_title_ref(item)
    item =~ /queue_item_(.*)/
    $1
  end

end
