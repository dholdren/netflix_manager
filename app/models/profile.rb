class Profile

  def self.from_json(json_profile)
    Profile.new(JSON.parse(json_profile))
  end
  
  def initialize(json_object)
    @json_delegate = json_object
  end
  
end
