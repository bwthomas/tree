module Bwthomas
  class TreeNodeError < StandardError; end

  class TreeNode
    attr_reader   :parent, :children
    attr_accessor :name

    def initialize(name=nil)
      @name       = name
      @children ||= []
    end

    def lineage
      !!(parent) ? parent.lineage + [self] : [self]
    end

    def trace
      lineage.map{|n| n.name || n.to_s}.join(" > ")
    end

    def traverse(stack=[], &block)
      children.each do |child|
        stack << child
        yield child if block_given?
        child.traverse stack, &block if child.respond_to?(:children) && child.respond_to?(:traverse)
      end
      stack
    end
    alias_method :search, :traverse

    def add_child(child)
      child.parent = self       if child.respond_to?(:parent=)
      children    << child  unless children.include?(child)
    end

    def parent_of?(child)
      return false unless children.include?(child)
      child.respond_to?(:parent) ? child.parent == self : true
    end

    def parent=(newp)
      if !!(newp)
        msg   = "Error: '#{newp}' cannot parent '#{self}'"  unless newp.respond_to?(:children)
        msg ||= "Error: '#{self}' is ancestor of '#{newp}'" if newp.lineage.include?(self)
        raise TreeNodeError, msg unless msg.nil?
      end

      oldp    = @parent
      @parent = newp

      oldp.children.delete(self)  if oldp && oldp.children && oldp.children.any?
      newp.children     << self   if newp && newp.children
      newp.children.uniq!     unless newp.nil?
    end

    def children=(newc)
      oldc      = @children
      @children = newc

      oldc.each  { |orphan|  orphan.parent  = nil  if orphan.respond_to?(:parent=)  }
      newc.each  { |adoptee| adoptee.parent = self if adoptee.respond_to?(:parent=)  }
    end

    def children_count
      children.size
    end

    def to_s
      param = !!(name) ? "'#{name}'" : 'nil'
      "#{self.class}.new(#{param})"
    end

  end
end
