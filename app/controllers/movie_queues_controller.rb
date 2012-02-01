class MovieQueuesController < ApplicationController
  before_filter :authenticate_user!  
  
  respond_to :json
  
  def move
    item = params["item"]
    from_queue_id = params["from"]
    from_etag = params["from_etag"]
    to_queue_id = params["to"]
    to_etag = params["to_etag"]
    position = params["position"]
    if item.blank? || from_queue_id.blank? || from_etag.blank? || to_queue_id.blank? || to_etag.blank? || position.blank?
      logger.error "[#{self.class.name}#move] one or more parameters were missing"
      return render :status => 500, :text => "{'exception': 'one or more parameters missing', 'params': #{params.to_json}}"
    end
    logger.debug "[#{self.class.name}#move]: item #{item}, from #{from_queue_id}, to #{to_queue_id}, from_etag #{from_etag}, to_etag #{to_etag}, position #{position}"
    
    from_queue = netflix_client_for_user.user(extract_user_id(from_queue_id)).available_disc_queue
    to_queue = netflix_client_for_user.user(extract_user_id(to_queue_id)).available_disc_queue
    
    item_title_ref = extract_title_ref(item)
    begin
      to_queue.add(item_title_ref, (position.to_i + 1))
      item =~ /.*\/(\d+)\/\d+$/
      item_position = $1
      #from_queue.remove(item)
      from_queue.remove(item_position)
      @profiles = current_user.profiles
      render :json => @profiles.to_json(:only => [:id, :name], :methods => :disc_queue)
    rescue
      logger.error "[#{self.class.name}#move] rescued: #{$!.inspect}"
      render :status => 500, :text => "{'exception': '#{$!.message}'}"
    end
  end
  
  
  private
  def extract_user_id(queue_id)
    queue_id =~ /users\/(.*?)\//
    $1
  end
  
  def extract_title_ref(item_id)
    item_id =~ /queues\/disc\/available\/\d+\/(\d+)/
    $1
  end

end
