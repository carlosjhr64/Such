module Such
  PARAMETERS = {}
  def self.define(clss, sprclss, header='include Such::Thing')
    eval <<-CODE
    class #{clss} < #{sprclss}
      #{header}
    end
    CODE
  end
end
