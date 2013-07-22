class TreeNode
  attr_accessor :name, :parent, :children

  def initialize(name=nil)
    @name       = name
    @children ||= []
  end

  def add_child(child)
    child.parent = self if child.respond_to?(:parent=)
    children << child
  end

  def parent_of?(child)
    return false unless children.include?(child)
    child.respond_to?(:parent) ? child.parent == self : true
  end

  def children_count
    children.size
  end
end
