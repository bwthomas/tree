require 'simplecov'
SimpleCov.start

$:.unshift File.join(File.dirname(__FILE__))

require 'test/unit'
require 'tree_node'

class TreeNodeInitializationTest < Test::Unit::TestCase

  def setup
    @tree_node = TreeNode.new
  end

  def test_accepts_and_sets_name_when_provided
    assert_equal( 'lorem', TreeNode.new('lorem').name,
                  'should use parameter for name when created' )
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

    children            = ['Donny', 'Marie']
    @tree_node.children = children
    assert_equal( children, @tree_node.children,
                  'should set children' )
    assert_equal( 2, @tree_node.children_count,
                  'should have two children when assigned to array with two elements' )
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
