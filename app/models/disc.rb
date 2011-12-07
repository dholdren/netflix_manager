class Disc
  attr_reader :id
  attr_reader :user_id
  attr_reader :queue_type #disc, instant
  attr_reader :queue_sub_type #available, saved
  attr_reader :entry_id #position
  attr_reader :title_ref #title_id
  attr_reader :title
  
  def self.convert_list(disc_queue_hash_array)
    discs = []
    #in case there is only one item, and it is a hash instead of an array of hashes
    disc_queue_hash_array = [disc_queue_hash_array].flatten
    disc_queue_hash_array.each {|queue_item|
      discs << Disc.new(queue_item)
    } if disc_queue_hash_array
    discs
  end
  
  def initialize(queue_item)
    @id = queue_item["id"]
    #@user_id = 
    @title = queue_item["title"]["regular"]
  end
  
end