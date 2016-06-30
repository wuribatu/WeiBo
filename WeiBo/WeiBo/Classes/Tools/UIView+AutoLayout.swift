//
//  UIView+AutoLayout.swift
//  XMGWeibo
//
//  Created by 李南江 on 15/9/1.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit
/**
    对齐类型枚举，设置控件相对于父视图的位置
  - TopLeft:      左上
  - TopRight:     右上
  - TopCenter:    中上
  - BottomLeft:   左下
  - BottomRight:  右下
  - BottomCenter: 中下
  - CenterLeft:   左中
  - CenterRight:  右中
  - Center: 中中
*/
public enum XMG_AlignType {
    case topLeft
    case topRight
    case topCenter
    case bottomLeft
    case bottomRight
    case bottomCenter
    case centerLeft
    case centerRight
    case center
    
    private func layoutAttributes(_ isInner: Bool, isVertical: Bool) -> XMG_LayoutAttributes {
        let attributes = XMG_LayoutAttributes()
        
        switch self {
            case .topLeft:
                attributes.horizontals(.left, to: .left).verticals(.top, to: .top)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.bottom, to: .top)
                } else {
                    return attributes.horizontals(.right, to: .left)
                }
            case .topRight:
                attributes.horizontals(.right, to: .right).verticals(.top, to: .top)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.bottom, to: .top)
                } else {
                    return attributes.horizontals(.left, to: .right)
                }
            case .bottomLeft:
                attributes.horizontals(.left, to: .left).verticals(.bottom, to: .bottom)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.top, to: .bottom)
                } else {
                    return attributes.horizontals(.right, to: .left)
                }
            case .bottomRight:
                attributes.horizontals(.right, to: .right).verticals(.bottom, to: .bottom)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.top, to: .bottom)
                } else {
                    return attributes.horizontals(.left, to: .right)
                }
            // 仅内部 & 垂直参照需要
            case .topCenter:
                attributes.horizontals(.centerX, to: .centerX).verticals(.top, to: .top)
                return isInner ? attributes : attributes.verticals(.bottom, to: .top)
            // 仅内部 & 垂直参照需要
            case .bottomCenter:
                attributes.horizontals(.centerX, to: .centerX).verticals(.bottom, to: .bottom)
                return isInner ? attributes : attributes.verticals(.top, to: .bottom)
            // 仅内部 & 水平参照需要
            case .centerLeft:
                attributes.horizontals(.left, to: .left).verticals(.centerY, to: .centerY)
                return isInner ? attributes : attributes.horizontals(.right, to: .left)
            // 仅内部 & 水平参照需要
            case .centerRight:
                attributes.horizontals(.right, to: .right).verticals(.centerY, to: .centerY)
                return isInner ? attributes : attributes.horizontals(.left, to: .right)
            // 仅内部参照需要
            case .center:
                return XMG_LayoutAttributes(horizontal: .centerX, referHorizontal: .centerX, vertical: .centerY, referVertical: .centerY)
        }
    }
}

extension UIView {
    

    /**
    填充子视图
    
    :param: referView 参考视图
    :param: insets    间距
    
    :returns: 约束数组
    */
    public func xmg_Fill(_ referView: UIView, insets: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[subView]-\(insets.right)-|", options: .alignAllLastBaseline, metrics: nil, views: ["subView" : self])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[subView]-\(insets.bottom)-|", options: .alignAllLastBaseline, metrics: nil, views: ["subView" : self])
        
        superview?.addConstraints(cons)
        
        return cons
    }

    /**
    参照参考视图内部对齐
    
    :param: type      对齐方式
    :param: referView 参考视图
    :param: size      视图大小，如果是 nil 则不设置大小
    :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
    
    :returns: 约束数组
    */
    public func xmg_AlignInner(type: XMG_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint]  {
        
        return xmg_AlignLayout(referView, attributes: type.layoutAttributes(true, isVertical: true), size: size, offset: offset)
    }

    /**
    参照参考视图垂直对齐
    
    :param: type      对齐方式
    :param: referView 参考视图
    :param: size      视图大小，如果是 nil 则不设置大小
    :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
    
    :returns: 约束数组
    */
    public func xmg_AlignVertical(type: XMG_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return xmg_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: true), size: size, offset: offset)
    }
    
    /**
    参照参考视图水平对齐
    
    :param: type      对齐方式
    :param: referView 参考视图
    :param: size      视图大小，如果是 nil 则不设置大小
    :param: offset    偏移量，默认是 CGPoint(x: 0, y: 0)
    
    :returns: 约束数组
    */
    public func xmg_AlignHorizontal(type: XMG_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return xmg_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: false), size: size, offset: offset)
    }

    /**
    在当前视图内部水平平铺控件
    
    :param: views  子视图数组
    :param: insets 间距
    
    :returns: 约束数组
    */
    public func xmg_HorizontalTile(_ views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.xmg_sizeConstraints(firstView)
            subView.xmg_AlignHorizontal(type: XMG_AlignType.topRight, referView: preView, size: nil, offset: CGPoint(x: insets.right, y: 0))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        addConstraints(cons)
        return cons
    }

    /**
    在当前视图内部垂直平铺控件
    
    :param: views  子视图数组
    :param: insets 间距
    
    :returns: 约束数组
    */
    public func xmg_VerticalTile(_ views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.xmg_AlignInner(type: XMG_AlignType.topLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.xmg_sizeConstraints(firstView)
            subView.xmg_AlignVertical(type: XMG_AlignType.bottomLeft, referView: preView, size: nil, offset: CGPoint(x: 0, y: insets.bottom))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        addConstraints(cons)
        
        return cons
    }

    /**
    从约束数组中查找指定 attribute 的约束
    
    :param: constraintsList 约束数组
    :param: attribute       约束属性
    
    :returns: 对应的约束
    */
    public func xmg_Constraint(_ constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }
    
    // MARK: - 私有函数
    /**
    参照参考视图对齐布局
    
    :param: referView  参考视图
    :param: attributes 参照属性
    :param: size       视图大小，如果是 nil 则不设置大小
    :param: offset     偏移量，默认是 CGPoint(x: 0, y: 0)
    
    :returns: 约束数组
    */
    private func xmg_AlignLayout(_ referView: UIView, attributes: XMG_LayoutAttributes, size: CGSize?, offset: CGPoint) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += xmg_positionConstraints(referView, attributes: attributes, offset: offset)
        
        if size != nil {
            cons += xmg_sizeConstraints(size!)
        }
        
        superview?.addConstraints(cons)
        
        return cons
    }
    

    /**
    尺寸约束数组
    
    :param: size 视图大小
    
    :returns: 约束数组
    */
    private func xmg_sizeConstraints(_ size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height))
        
        return cons
    }
    

    /**
    尺寸约束数组
    
    :param: referView 参考视图，与参考视图大小一致
    
    :returns: 约束数组
    */
    private func xmg_sizeConstraints(_ referView: UIView) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0))
        
        return cons
    }
    
    /**
    位置约束数组
    
    :param: referView  参考视图
    :param: attributes 参照属性
    :param: offset     偏移量
    
    :returns: 约束数组
    */
    private func xmg_positionConstraints(_ referView: UIView, attributes: XMG_LayoutAttributes, offset: CGPoint) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referVertical, multiplier: 1.0, constant: offset.y))
        
        return cons
    }
}

///  布局属性
private final class XMG_LayoutAttributes {
    var horizontal:         NSLayoutAttribute
    var referHorizontal:    NSLayoutAttribute
    var vertical:           NSLayoutAttribute
    var referVertical:      NSLayoutAttribute
    
    init() {
        horizontal = NSLayoutAttribute.left
        referHorizontal = NSLayoutAttribute.left
        vertical = NSLayoutAttribute.top
        referVertical = NSLayoutAttribute.top
    }
    
    init(horizontal: NSLayoutAttribute, referHorizontal: NSLayoutAttribute, vertical: NSLayoutAttribute, referVertical: NSLayoutAttribute) {
        
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    private func horizontals(_ from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        horizontal = from
        referHorizontal = to
        
        return self
    }
    
    private func verticals(_ from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        vertical = from
        referVertical = to
        
        return self
    }
}
