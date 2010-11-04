# Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009 Gregoire Lejeune <gregoire.lejeune@free.fr>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA

require 'graphviz/attrs'
require 'graphviz/constants'

class GraphViz
  class Edge
    include Constants
    @xNodeOne
    @xNodeTwo
    @oAttrEdge
    @oGParrent

    # 
    # Create a new edge
    # 
    # In:
    # * vNodeOne : First node
    # * vNodeTwo : Second node
    # * oGParrent : Graph 
    #
    def initialize( vNodeOne, vNodeTwo, oGParrent = nil )
	    if vNodeOne.class == String
        @xNodeOne = vNodeOne
	    else
        @xNodeOne = vNodeOne.name
	    end
	  
	    if vNodeTwo.class == String
        @xNodeTwo = vNodeTwo
	    else
        @xNodeTwo = vNodeTwo.name
	    end
	    
	    @oGParrent = oGParrent

      @oAttrEdge = GraphViz::Attrs::new( nil, "edge", EDGESATTRS )
    end

    # 
    # Set value +xAttrValue+ to the edge attribut +xAttrName+
    # 
	  def []=( xAttrName, xAttrValue )
      xAttrValue = xAttrValue.to_s if xAttrValue.class == Symbol
      @oAttrEdge[xAttrName.to_s] = xAttrValue
    end

    # 
    # Set values for edge attributs or 
    # get the value of the given edge attribut +xAttrName+
    # 
    def []( xAttrName )
      # Modification by axgle (http://github.com/axgle)
      if Hash === xAttrName
        xAttrName.each do |key, value|
          self[key] = value
        end
      else
        @oAttrEdge[xAttrName.to_s].clone
      end
    end
    
    def <<( oNode ) #:nodoc:
      n = @oGParrent.get_node(@xNodeTwo)
      
      GraphViz::commonGraph( oNode, n ).add_edge( n, oNode )
    end
    alias :> :<< #:nodoc:
    alias :- :<< #:nodoc:
    alias :>> :<< #:nodoc:
    
    #
    # Set edge attributs
    #
    # Example :
    #   e = graph.add_edge( ... )
    #   ...
    #   e.set { |_e|
    #     _e.color = "blue"
    #     _e.fontcolor = "red"
    #   }
    # 
    def set( &b )
      yield( self )
    end
    
    # Add edge options
    # use edge.<option>=<value> or edge.<option>( <value> )
    def method_missing( idName, *args, &block ) #:nodoc:
      xName = idName.id2name
      
      self[xName.gsub( /=$/, "" )]=args[0]
    end
    
	  def output( oGraphType ) #:nodoc:
	    xLink = " -> "
	    if oGraphType == "graph"
	      xLink = " -- "
	    end
	  
	    #xNodeNameOne = @xNodeOne.clone
	    #xNodeNameOne = '"' << xNodeNameOne << '"' if xNodeNameOne.match( /^[a-zA-Z_]+[a-zA-Z0-9_\.]*$/ ).nil?
	    xNodeNameOne = GraphViz.escape(@xNodeOne)
	    
	    #xNodeNameTwo = @xNodeTwo.clone
	    #xNodeNameTwo = '"' << xNodeNameTwo << '"' if xNodeNameTwo.match( /^[a-zA-Z_]+[a-zA-Z0-9_\.]*$/ ).nil?
	    xNodeNameTwo = GraphViz.escape(@xNodeTwo)
      
      xOut = xNodeNameOne + xLink + xNodeNameTwo
      xAttr = ""
      xSeparator = ""
      @oAttrEdge.data.each do |k, v|
        xAttr << xSeparator + k + " = " + v.to_gv
        xSeparator = ", "
      end
      if xAttr.length > 0
        xOut << " [" + xAttr + "]"
      end
      xOut + ";"

      return( xOut )
	  end
  end
end
