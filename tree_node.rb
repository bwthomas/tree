class TreeNode
  attr_reader   :parent
  attr_accessor :name, :children

  def initialize(name=nil)
    @name       = name
    @children ||= []
  end

  def add_child(child)
    child.parent = self       if child.respond_to?(:parent=)
    children    << child  unless children.include?(child)
  end

  def parent_of?(child)
    return false unless children.include?(child)
    child.respond_to?(:parent) ? child.parent == self : true
  end

  def parent=(new)
    old     = @parent
    @parent = new

    old.children.delete(self)     if old && old.children.any?
    new.children     << self  unless new.children.include?(self)
  end

  def children_count
    children.size
  end
end
