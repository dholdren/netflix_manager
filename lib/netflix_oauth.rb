module Netflix
  class Queue
    
    def id
      "/users/#{@user_id}/queues/#{@type}"
    end
    
    def as_json
      _discs = self.discs.map() {|disc| {:id => disc.id, :title => disc.id}}
      {:id => self.id, :etag => self.etag, :discs => _discs}
    end
  end
  
  class Disc
    def id
      @map["id"] =~ /(\/users.*)/
      $1
    end
  end
end