require 'test-unit'
require 'simplecov'
SimpleCov.start

require 'bwthomas'
include Bwthomas

class TreeNodeInitializationTest < Test::Unit::TestCase

  def setup
    @tree_node = TreeNode.new
  end

  def test_accepts_and_sets_name_when_provided
    assert_equal( 'lorem', TreeNode.new('lorem').name,
                  'should use parameter for name when created' )
  end

  def test_uses_name_when_converting_to_string
    node = TreeNode.new('lorem')
    assert_equal( "Bwthomas::TreeNode.new('lorem')", node.to_s,
                  'should convert to a meaningful string when name is present' )

    assert_equal( "Bwthomas::TreeNode.new(nil)", @tree_node.to_s,
                  'should convert to a meaningful string when name is not present' )
  end

  def test_has_no_name_by_default_when_created
    assert_nil(@tree_node.name)
  end

  def test_has_no_children_when_created
    assert_equal( 0, @tree_node.children_count,
                  'should have an empty children array when created' )
  end

  def test_has_no_parent_when_created
    assert_nil(@tree_node.parent)
  end

end

class TreeNodeAttrAccessorTest < Test::Unit::TestCase

  def setup
    @tree_node = TreeNode.new
  end

  def test_setting_name
    assert_nil(@tree_node.name)

    @tree_node.name = 'ipsum'
    assert_equal( 'ipsum', @tree_node.name,
                  'should set name' )
  end

  def test_setting_parent
    assert_nil(@tree_node.parent)

    parent            = TreeNode.new('mommy dearest')
    @tree_node.parent = parent
    assert_equal( parent, @tree_node.parent,
                  'should set parent' )
  end

  def test_setting_children
    assert_empty(@tree_node.children)

    children            = [TreeNode.new('Donny'), TreeNode.new('Marie')]
    new_children        = ['Greg', 'Marsha']

    @tree_node.children = children

    assert_equal( children, @tree_node.children,
                  'should set children' )
    assert_equal( 2, @tree_node.children_count,
                  'should have two children when assigned to array with two elements' )
    assert_equal( 1, children.map(&:parent).uniq.size,
                  'should set same parent on all children nodes' )
    assert_equal( @tree_node, children.map(&:parent).uniq.first,
                  'should set parent on children nodes when possible' )

    @tree_node.children = new_children

    assert_equal( 0, children.map(&:parent).compact.size,
                  'should unset parent on old children nodes' )
  end

end

class TreeNodeChildAssignmentTest < Test::Unit::TestCase

  def setup
    @tree_node  = TreeNode.new
    @child_node = TreeNode.new
    @tree_node.add_child(@child_node)
  end

  def test_parent_of
    assert_equal( true, @tree_node.parent_of?(@child_node),
                  'should respond true as parent of child node' )
    assert_equal( false, @tree_node.parent_of?(7),
                  'should respond false when not parent of child node' )
  end

  def test_children_count
    assert_equal( 1, @tree_node.children_count,
                  'should have a single child when one is added' )
  end

  def test_parent_assignment
    assert_equal( @tree_node, @child_node.parent,
                  'should assign parent to child attribute when possible')

    @tree_node.add_child(7)

    assert_equal( true, @tree_node.parent_of?(7),
                  'should accomodate non-TreeNode children' )
  end

end

class TreeNodeParentAssignmentTest < Test::Unit::TestCase

  def setup
    @tree_node  = TreeNode.new
    @child_node = TreeNode.new
    @tree_node.add_child(@child_node)
  end

  def test_parent_assignment_removes_child_from_children
    new_parent = TreeNode.new('my new pa-pa')
    @child_node.parent = new_parent
    assert_equal( false, @tree_node.children.include?(@child_node),
                  'should remove child node from array of children' )
  end

end

class TreeNodeGraphTest < Test::Unit::TestCase

  ## Visualization really helps.
  ## (20130722, BWT)
  #                           root
  #                          /    \
  #                        /        \
  #                      /            \
  #                    /                \
  #                  /                    \
  #                /                        \
  #           delta                          gamma
  #         /       \                      /       \
  #       /           \                  /           \
  #     y0             z0              y1              z1
  #   /    \         /     \         /     \         /    \
  #  q      r       s       t       u       v       w       x
  # / \    / \     / \     / \     / \     / \     / \     / \
  # a  b  c   d   e   f   g   h   i   j   k   l   m   n   o   p

  def setup
    @root     = TreeNode.new('root')

    trunks    = ['delta', 'gamma'].map {|l| TreeNode.new(l)}
    trunks.each {|t| @root.add_child(t)}
    @trunk = trunks.last

    branches    = ['y0', 'z0', 'y1', 'z1'].map {|l| TreeNode.new(l)}
    branches.each {|l| trunks[branches.index(l) % trunks.size].add_child(l)}
    @branch = branches.last

    baughs    = ('q'..'x').map {|l| TreeNode.new(l)}
    baughs.each {|l| branches[baughs.index(l) % branches.size].add_child(l)}
    @baugh = baughs.last

    leaves    = ('a'..'p').map {|l| TreeNode.new(l)}
    leaves.each {|l| baughs[leaves.index(l) % baughs.size].add_child(l)}
    @leaf = leaves.last

    t = TreeNode.new('A')
    t.children  = [TreeNode.new('B'), TreeNode.new('C')]
    t.children.first.children = [TreeNode.new('D'), TreeNode.new('E')]
    t.children.first.children.last.children = [TreeNode.new('F'), TreeNode.new('G')]

    @given_example = t

    @traversal = %w(delta y0 q a i u e m y1 s c k w g o gamma z0 r b j v f n z1 t d l x h p)
  end

  def test_tree_node_lineage
    assert_equal( [@root, @trunk, @branch, @baugh, @leaf], @leaf.lineage,
                  'should traverse path to root node & produce a list' )
  end

  def test_tree_node_trace
    assert_equal( 'root > gamma > z1 > x > p', @leaf.trace,
                  'should traverse path to root node & produce a string' )
  end

  def test_tree_node_search
    assert_equal( @traversal, @root.search.map(&:name),
                  'should traverse entire tree & produce a list of nodes' )

    assert_equal( %w(B D E F G C), @given_example.search.map(&:name),
                  'should traverse entire tree & produce a list of nodes' )
  end
end
