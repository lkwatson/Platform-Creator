# Platform Creator
This small program allows a user to attempt to fill defined boxes with a set of predefined tables. Built in Lua with Love2d

The intended application of this program is to allow a theatrical stage designer to draw a desired set of platforms, and
quickly create a draft of where smaller platforms can be placed together to form a multi-level stage

The greater scope of this program is its application in solving the NP-Hard "Bin Packing" problem. 

##How to use
Download the love2d application from https://love2d.org/
When compiled, having the love2d application isn't necessary. However for a development environment its much easier
to not need to compile for every change. 

The current controls are via the keyboard. Pressing "S" selects the square tool to draw squares that will be filled with
a set of platforms upon processing, by pressing the "P" key twice. Pressing the "L" key allows the user to draw lines, 
simply for the purpose of measurment. 

##Why did you use a gaming framework and lua to create this?!
Love2d makes graphics simple, and easy to read for those looking at, and modifying the source. Its also very easy to compile
binaries for Windows, Linux, and Mac. 
