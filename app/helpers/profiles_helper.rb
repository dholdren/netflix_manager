module ProfilesHelper

  def user_id(url)
    user_id = nil
    if user_url =~ /https?:\/\/api.netflix.com\/users\/([^\/]*)\/.*/
      url_segment = $1
      user_id = URI.escape(url_segment)
    end
    user_id
  end
  
  def queue_id(queue_url)
    queue_id = nil
    if queue_url =~ /https?:\/\/api.netflix.com\/users\/((?:[^\/]*)\/queues\/disc\/available).*/
      url_segment = $1
      queue_id = URI.escape(url_segment)
    end
    queue_id
  end
  
  def title_id(item_url)
    item_id = nil
    if item_url =~ /https?:\/\/api.netflix.com\/users\/(?:[^\/]*)\/queues\/disc\/available\/\d+\/(\d+).*/
      item_id = $1
    end
    item_id
  end
end
