/*
    This class represents the classic puzzle sliding game with the Niles West image sliced into
    16 different subimages (the last one is thrown away and replaced with a gray image)
*/

import Foundation
import UIKit


class SlidingPuzzleView: UIView {

    //the number of rows and columns in the tile game
    var numRows : Int = 4
    var numCols : Int = 4

    //the full image
    var image : UIImage = UIImage(named: "niles-west.jpg")!
    
    //a 2D array of UIImage objects
    //the current arry has 0 rows and 0 columns
    var images : [[UIImage]] = Array<Array<UIImage>>()
    
    //the "open" image where the user can click
    var grayImage : UIImage!
    
    //the row and column in the grid where the open image exists
    var grayRow : Int = -1
    var grayCol : Int = -1
    
    //this function is called after the width and height of the frame has already been determined and any
    //subviews (which we don't have) will be layed out.  Here we will do the image slicing and 2D array
    //population
    override func layoutSubviews() {

        super.layoutSubviews()
        
        //this method was getting called more than once... for some reason...
        //so we'll return to make sure we don't do all this work twice and mess up
        //our array
        if(grayRow != -1) {
            return;
        }
        
        //the width and height of the view
        var width : CGFloat = self.bounds.width
        var height : CGFloat = self.bounds.height
        
        //loop over every row in the tile game
        var y : CGFloat = 0
        for(var row = 0; row < numRows; row++) {
        
            //add a subrow to the 2D array that is empty
            images.append(Array<UIImage>());
        
            //loop overy every column within the current row
            var x : CGFloat = 0
            for(var col = 0; col < numCols; col++) {
            
                //create a subimage from the main image
                var subImage = getSubImage(image, fromRect: CGRectMake(x, y, width/CGFloat(numCols), height/CGFloat(numRows)))
                
                //add the subimage to the current row
                images[row].append(subImage)
                
                //increase the x-coordinate by the width of a tile
                x += width/CGFloat(numCols)
            }
            
            //increase the y-coordinate by the height of a tile
            y += height/CGFloat(numRows)
        }
        
        //replace the bottom right hand corner with a new gray image
        images[numRows-1][numCols-1] = getImageWith(UIColor.grayColor(), size: CGSizeMake(width/CGFloat(numCols), height/CGFloat(numRows)));
        grayImage = images[numRows-1][numCols-1]
        grayRow = numRows - 1
        grayCol = numCols - 1
        
        //randomize the order of tiles in the game
        randomize()
    }
    
    //this function randomly selects "moves" in the game and executes them to generate a random block arrangement that is solvable
    //this is superior to just switching random tiles, as that could generate a potentially unwinnable tile configuration
    func randomize() {
    
        /*INSERT YOUR CODE*/
        
        /*STOP INSERTING YOUR CODE*/
    }
    
    //this function creates an image with the given color and size
    func getImageWith(color: UIColor, size: CGSize) -> UIImage {
    
        //start an image creation context with the given size
        UIGraphicsBeginImageContext(size)
        var context = UIGraphicsGetCurrentContext();
        
        //set the color and fill a rectangle with the given size
        color.set();
        UIBezierPath(rect: CGRectMake(0, 0, size.width, size.height)).fill()
        
        //get the resulting image and return the newly created img after ending the drawing context
        var img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return img
    }
    
    //this function creates a subimage from the given image, taken from the given rect from within the image
    func getSubImage(img : UIImage, fromRect: CGRect) -> UIImage {
    
        //start an image creation context with the given size
        UIGraphicsBeginImageContext(fromRect.size)
        var context = UIGraphicsGetCurrentContext();
        
        //we are going to shift the image to the left and up so that the portion we want will now be in the
        //upper left hand corner
        var drawRect = CGRectMake(-fromRect.origin.x, -fromRect.origin.y, img.size.width, img.size.height)

        //clip the drawing area to just be the upper left hand corner with the rect size (not the full original image size)
        CGContextClipToRect(context, CGRectMake(0, 0, fromRect.size.width, fromRect.size.height))
        
        //draw the full image in our drawing rectangle which has been shifted and clipped
        img.drawInRect(drawRect)
        
        //draw a dark black line around the image
        UIColor.blackColor().set();
        UIBezierPath(rect: CGRectMake(0, 0, fromRect.size.width, fromRect.size.height)).stroke()
        
        //get the resulting image and return the newly created img after ending the drawing context
        var subImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return subImage
    }
    
    //this function is automatically called to draw the contents of the UIView - it draws all the tile pieces
    override func drawRect(rect: CGRect) {
        
        //get the width and height of the view
        var width : CGFloat = self.bounds.width
        var height : CGFloat = self.bounds.height
        
       /*INSERT YOUR CODE*/
        
        /*STOP INSERTING YOUR CODE*/
    }
    
    //this function is automatically called when the UIView is touched - we will use this to determine
    //if the user has touched a block adjacent to the gray image, and if so, swicth the blocks
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
        //see if we have a valid touch event
        if let touch =  touches.first as? UITouch {
        
            //if so, get the location of the touch within the UIView
            var loc : CGPoint = touch.locationInView(self)
            
            //get the width and height of the UIView
            var width : CGFloat = self.bounds.width
            var height : CGFloat = self.bounds.height
            
            /*INSERT YOUR CODE*/
        
            /*STOP INSERTING YOUR CODE*/
            
            //mark the UIView as needing to be redisplayed
            setNeedsDisplay()
        }
    }

}