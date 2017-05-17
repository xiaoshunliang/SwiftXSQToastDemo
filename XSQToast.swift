//
//  XSQToast.swift
//  XSQToast
//
//  Created by xiaoshunliang on 2017/5/17.
//  Copyright © 2017年 bodaokeji. All rights reserved.
//

import UIKit

extension String {
    /**
     * 查询lable高度
     * @param fontSize, 字体大小
     * @param width, lable宽度
     */
    func getLableHeightByWidth(_ fontSize: CGFloat,
                               width: CGFloat,
                               font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
}

extension UILabel {
    //根据最大宽度计算宽高
    func getLableSize(text: String, maxWidth: CGFloat) -> CGRect {
        let maxSize = CGSize(width: maxWidth, height: 0)   //注意高度是0
        let size = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin,
                                     attributes: [NSFontAttributeName:self.font], context: nil)
        return size
        
    }
}

class XSQToast: NSObject {
    var delay: Double = 2.0  //延迟时间
    
    var bufWindows: [UIWindow] = []    //缓存window
    //加载进度框
    func showLoading() {
        let rootRect = UIApplication.shared.windows.first?.frame   //应用屏幕大小
        let container = UIView()   //全屏且透明，盖在最上面， 可以自定义点击事件
        container.backgroundColor = UIColor.clear
        container.frame = rootRect!
        
        //添加中间矩形黑色区域, 80*80
        let bgLength = 90
        let bgView = UIView()  //黑色半透明方形区域
        bgView.frame = CGRect(x: Int((rootRect?.width)!/2) - bgLength/2,
                              y: Int((rootRect?.height)!/2) - bgLength/2,
                              width: bgLength,
                              height: bgLength)
        bgView.layer.cornerRadius = 10   //黑色矩形区域的角弧度
        bgView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.8)
        
        container.addSubview(bgView)   //全屏透明背景在中心位置添加矩形黑色区域
        
        //添加圈圈
        let indicatorLength: CGFloat = 50  //黑色矩形区域里的旋转
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.frame = CGRect(x: (rootRect?.width)!/2 - indicatorLength/2,
                                     y: (rootRect?.height)!/2 - indicatorLength/2 - 10,
                                     width: indicatorLength,
                                     height: indicatorLength)
        indicatorView.startAnimating()   //动画
        
        container.addSubview(indicatorView)  //添加旋转动画view
        
        //添加文字
        let lableX = (rootRect?.width)!/2 - CGFloat(bgLength/2) + 5
        let lableY = (rootRect?.height)!/2 + indicatorLength/2 - 10
        let lableView = UILabel(frame: CGRect(x: Int(lableX),
                                              y: Int(lableY),
                                              width: bgLength-10,
                                              height: bgLength/2-Int(indicatorLength)/2-5))
        lableView.font = UIFont.systemFont(ofSize: 15)    //设置系统字体和字号
        lableView.textColor = UIColor.white
        lableView.text = "加载中..."
        lableView.textAlignment = .center
        container.addSubview(lableView)
        
        
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.frame = rootRect!    //全屏大小
        window.center = CGPoint(x: (rootRect?.width)!/2, y: (rootRect?.height)!/2)
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(container)
        bufWindows.append(window)
        perform(#selector(showFinished(sender:)), with: window, afterDelay: delay)
    }
    
    //显示toast
    func showToast(_ text: String) {
        let rootRect = UIApplication.shared.windows.first?.frame   //应用屏幕大小
        
        let container = UIView()   //全屏且透明，盖在最上面， 可以自定义点击事
        container.backgroundColor = UIColor.clear
        container.frame = rootRect!
        let lableView = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        lableView.font = UIFont.systemFont(ofSize: 14)
        lableView.textColor = UIColor.white
        lableView.text = text
        lableView.textAlignment = .center
        lableView.numberOfLines = 1
        
        let rect = lableView.getLableSize(text: text, maxWidth: 300)
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.8)
        bgView.layer.cornerRadius = 5
        var bgRect: CGRect    //黑色半透明背景
        
        lableView.frame = CGRect(x: (rootRect?.width)!/2 - rect.width/2,
                                 y: (rootRect?.height)!/2 - rect.height/2 ,
                                 width: rect.width,
                                 height: rect.height)
        bgRect = CGRect(x: lableView.frame.minX - 5,
                        y: lableView.frame.minY - 5,
                        width: rect.width + 10,
                        height: rect.height + 10)
        bgView.frame = bgRect
        
        container.addSubview(bgView)
        container.addSubview(lableView)  //添加lableView
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.frame = rootRect!
        window.center = container.center
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(container)
        bufWindows.append(window)
        perform(#selector(showFinished(sender:)), with: window, afterDelay: delay)
    }
    //toast超时关闭
    func showFinished(sender: AnyObject) {
        if let window = sender as? UIWindow {
            if let index = bufWindows.index(of: window) {
                bufWindows.remove(at: index)  //删除
            }
        } else {
            //do nothing
        }
    }
    
    
}

