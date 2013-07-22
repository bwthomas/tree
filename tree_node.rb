class TreeNode
  attr_accessor :name, :parent, :children

  def initialize(name=nil)
    @name       = name
    @children ||= []
  end

  def add_child(child)
    child.parent = self
    children << child
  end

  def children_count
    children.size
  end
end
