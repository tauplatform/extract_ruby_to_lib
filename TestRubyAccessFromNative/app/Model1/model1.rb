# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Model1
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with Model1.
  # enable :sync

  #add model specific code here

  def self.getAllItems
      items = Model1.find(:all)
      puts "$$$$$ items = "+items.to_s
      puts "$$$$$ items.class = "+items.class.to_s
      puts "$$$$$ items.class.name = "+items.class.name.to_s
      items
  end

  def self.getAllItemsAsHashes
      items = Model1.find(:all)
      ar = []
      items.each do |model1|
          h = {}
          h["attr1"] = model1.attr1
          h["attr2"] = model1.attr2
          h["attr3"] = model1.attr3
          ar << h
      end
      ar
  end


  def self.fillModelByPredefinedSet
      item = Model1.new({'attr1' => 'ZORRRRO', 'attr2' => 'XORRRO', 'attr3' => 'CORRRRO'})
      item.save
      item = Model1.new({'attr1' => '111', 'attr2' => '222', 'attr3' => '333'})
      item.save
  end

  def self.callNativeCallback(param1)
      #puts "$$$$$ Model1.callNativeCallback() param = "+param.to_s
      puts "$$$$$ Model1.callNativeCallback() param1 = "+param1.to_s

      Rho::Ruby.callNativeCallback("myCallback01", "testString result 777");
  end



end
