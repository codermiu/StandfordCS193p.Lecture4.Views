//
//  FaceView.swift
//  StandfordCS193p.Lecture4.Views
//
//  Created by Daning Miao on 12/7/18.
//  Copyright © 2018 Daning Miao. All rights reserved.
// create a new class for a new UI, and custom class new UI to this class in the storyboard

import UIKit

@IBDesignable
class FaceView: UIView {
    
    // Use scale * SkullRadius make the circle smaller and change the content mode under view setting in the storyboard, from default fit to scale to redraw
    var scale: CGFloat = 0.9
    
    // can change true or false to control eye open or close
    @IBInspectable
    var eyesOpen : Bool = true
    
    // control the mouth shape
    
    var mouthCurvature: Double = 1.0 // 1.0 is full smile and -1.0 is full frown by adding 4 control points on the mouth rectangle
    
    
    /* note: “Define the access level for an entity by placing one of the open, public, internal, fileprivate, or private modifiers before the entity’s introducer:”
     
     Encapsulation means basically that information and states of a class should be hidden from outside of the class – only the class itself should manipulate it. As a consequence, both bugs and logical errors are much more unlikely.
     
     Normally you are using setters and getters to achieve this. However, sometimes you don’t want to provide a setter outside of the class at all. For that scenario you can use properties with private setters.
     
     Example
     So imagine we want to create a class that represents a circle. It should be possible to change the radius. Furthermore, both the area and the diameter should be accessible from the Circle instance. It should not be allowed to manipulate the diameter or the area from outside of the class. For performance reasons, the area and diameter should only be calculated once.
    */
    private var skullRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height)/2 * scale
        
    }
    
    private var skullCenter: CGPoint{
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye{
        case left
        case right
    }
    
    private func pathForEye(_ eye:Eye) -> UIBezierPath{
        // set the center of the eye
        func centerOfEye(_ eye: Eye) -> CGPoint{
            let eyeOffset = skullRadius/Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
            }
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        
        let path: UIBezierPath
        if eyesOpen{
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
            }else{
                path = UIBezierPath()
                path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
                path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            }
                
                
                path.lineWidth = 5.0
                return path
            }
  /*  we later improve into 2 situation eyes open and close, the following code just include situation when the eyes are open
             
             //move up is minus the offset, down is increase compared to the center. intially we set eye center as skull center need to move
            eyeCenter.y -= eyeOffset
            // depend on whether eye is left or right, need to add or minus offset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        // so need to know the key paramaters for UIBezierPath including center, radius, startAngle, endAngle... each time. In order to the path of our drawing, and use stroke function stroke() to draw in the view.
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        path.lineWidth = 5.0
        
        return path
 
 */
    
    private func pathForMouth() -> UIBezierPath{
        let mouthWith = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWith/2, y: skullCenter.y + mouthOffset, width: mouthWith, height: mouthHeight)
        
        //mouth curve
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        //add point on mouth rectangle to control the shape of mouth
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: start.x + mouthRect.width/3, y:start.y+smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width/3, y:start.y+smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = 5.0
        
        return path
    }
        
    
    
    private func pathForSkull()->UIBezierPath{
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        path.lineWidth = 5.0
        return path
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.blue.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()

    /* original codes before reconstruct
        let skullRadius = min(bounds.size.width, bounds.size.height)/2 * scale
        let skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        // draw a circle, the type for UIBzierpath is CGFloat, so we use CGFloat.pi here, rather than Double.pi
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
        path.lineWidth = 5.0
        UIColor.blue.set()
        path.stroke()
      */
    }
    
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
         static let skullRadiusToEyeRadius: CGFloat = 10
         static let skullRadiusToMouthWidth: CGFloat = 1
         static let skullRadiusToMouthHeight: CGFloat = 3
         static let skullRadiusToMouthOffset: CGFloat = 3
     
    }
}
