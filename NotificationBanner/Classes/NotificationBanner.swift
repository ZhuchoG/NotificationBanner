/*
 
 The MIT License (MIT)
 Copyright (c) 2017-2018 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

import MarqueeLabel

@objcMembers
open class NotificationBanner: BaseNotificationBanner {
    
    /// The bottom most label of the notification if a subtitle is provided
    public private(set) var subtitleLabel: MarqueeLabel?
    
    /// The view that is presented on the left side of the notification
    private var leftView: UIView?
    
    /// The view that is presented on the right side of the notification
    private var rightView: UIView?
    
    /// Font used for the title label
    private var titleFont: UIFont = UIFont.systemFont(ofSize: 17.5, weight: UIFont.Weight.bold)
    
    /// Font used for the subtitle label
    private var subtitleFont: UIFont = UIFont.systemFont(ofSize: 15.0)

    public init(title: String? = nil,
                subtitle: String? = nil,
                leftView: UIView? = nil,
                rightView: UIView? = nil,
                style: BannerStyle = .info,
                colors: BannerColorsProtocol? = nil) {
        
        super.init(style: style, colors: colors)
        
        if let leftView = leftView {
            contentView.addSubview(leftView)
            leftView.translatesAutoresizingMaskIntoConstraints = false
            let size = (leftView.frame.height > 0) ? min(44, leftView.frame.height) : 44
            [leftView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: heightAdjustment / 4),
            leftView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            leftView.heightAnchor.constraint(equalToConstant: size),
            leftView.widthAnchor.constraint(equalToConstant: size)]
                .forEach { $0.isActive = true }
        }
        
        if let rightView = rightView {
            contentView.addSubview(rightView)
            rightView.translatesAutoresizingMaskIntoConstraints = false
            let size = (rightView.frame.height > 0) ? min(44, rightView.frame.height) : 44
            [rightView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: heightAdjustment / 4),
            rightView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            rightView.heightAnchor.constraint(equalToConstant: size),
            rightView.widthAnchor.constraint(equalToConstant: size)]
               .forEach { $0.isActive = true }
        }
        
        let labelsView = UIView()
        contentView.addSubview(labelsView)
        labelsView.translatesAutoresizingMaskIntoConstraints = false
        
        if let title = title {
            titleLabel = MarqueeLabel()
            (titleLabel as! MarqueeLabel).type = .left
            titleLabel!.font = titleFont
            titleLabel!.textColor = .white
            titleLabel!.text = title
            labelsView.addSubview(titleLabel!)
            titleLabel?.translatesAutoresizingMaskIntoConstraints = false
            [titleLabel!.topAnchor.constraint(equalTo: labelsView.topAnchor),
             titleLabel!.leftAnchor.constraint(equalTo: labelsView.leftAnchor),
             titleLabel!.rightAnchor.constraint(equalTo: labelsView.rightAnchor)]
                .forEach { $0.isActive = true}
            
            if let _ = subtitle {
                titleLabel!.numberOfLines = 1
            } else {
                titleLabel!.numberOfLines = 2
            }
        }
        
        if let subtitle = subtitle {
            subtitleLabel = MarqueeLabel()
            subtitleLabel!.type = .left
            subtitleLabel!.font = subtitleFont
            subtitleLabel!.numberOfLines = 1
            subtitleLabel!.textColor = .white
            subtitleLabel!.text = subtitle
            labelsView.addSubview(subtitleLabel!)
            subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
            if title != nil {
                [subtitleLabel!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 2.5),
                subtitleLabel!.leftAnchor.constraint(equalTo: titleLabel!.leftAnchor),
                subtitleLabel!.rightAnchor.constraint(equalTo: titleLabel!.rightAnchor)]
               .forEach { $0.isActive = true}
           }
           else {
                [subtitleLabel!.topAnchor.constraint(equalTo: labelsView.topAnchor),
               subtitleLabel!.leftAnchor.constraint(equalTo: labelsView.leftAnchor),
               subtitleLabel!.rightAnchor.constraint(equalTo: labelsView.rightAnchor)]
                  .forEach { $0.isActive = true}
           }
        }
        
        labelsView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: heightAdjustment / 4).isActive = true
        if let leftView = leftView {
            labelsView.leftAnchor.constraint(equalTo: leftView.rightAnchor, constant: padding).isActive = true
       } else {
            labelsView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding).isActive = true
       }

       if let rightView = rightView {
            labelsView.rightAnchor.constraint(equalTo: rightView.leftAnchor, constant: -padding).isActive = true
       } else {
            labelsView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding).isActive = true
       }

       if let subtitleLabel = subtitleLabel {
        labelsView.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor).isActive = true
       } else {
        labelsView.bottomAnchor.constraint(equalTo: titleLabel!.bottomAnchor).isActive = true
       }
        
        updateMarqueeLabelsDurations()
        
    }
    
    public convenience init(attributedTitle: NSAttributedString,
                            attributedSubtitle: NSAttributedString? = nil,
                            leftView: UIView? = nil,
                            rightView: UIView? = nil,
                            style: BannerStyle = .info,
                            colors: BannerColorsProtocol? = nil) {
        
        let subtitle: String? = (attributedSubtitle != nil) ? "" : nil
        self.init(title: "", subtitle: subtitle, leftView: leftView, rightView: rightView, style: style, colors: colors)
        titleLabel!.attributedText = attributedTitle
        subtitleLabel?.attributedText = attributedSubtitle
    }
    
    public init(customView: UIView) {
        super.init(style: .customView)
        self.customView = customView
        
        contentView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        [customView.topAnchor.constraint(equalTo: contentView.topAnchor),
        customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        customView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        customView.rightAnchor.constraint(equalTo: contentView.rightAnchor)]
           .forEach { $0.isActive = true }
        
        spacerView.backgroundColor = customView.backgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func updateMarqueeLabelsDurations() {
        super.updateMarqueeLabelsDurations()
        subtitleLabel?.speed = .duration(CGFloat(duration <= 3 ? 0.5 : duration - 3))
    }
    
}

public extension NotificationBanner {
    
    func applyStyling(cornerRadius: CGFloat? = nil,
                      titleFont: UIFont? = nil,
                      titleColor: UIColor? = nil,
                      titleTextAlign: NSTextAlignment? = nil,
                      subtitleFont: UIFont? = nil,
                      subtitleColor: UIColor? = nil,
                      subtitleTextAlign: NSTextAlignment? = nil) {
        
        if let cornerRadius = cornerRadius {
            contentView.layer.cornerRadius = cornerRadius
        }
        
        if let titleFont = titleFont {
            titleLabel!.font = titleFont
        }
        
        if let titleColor = titleColor {
            titleLabel!.textColor = titleColor
        }
        
        if let titleTextAlign = titleTextAlign {
            titleLabel!.textAlignment = titleTextAlign
        }
        
        if let subtitleFont = subtitleFont {
            subtitleLabel!.font = subtitleFont
        }
        
        if let subtitleColor = subtitleColor {
            subtitleLabel!.textColor = subtitleColor
        }
        
        if let subtitleTextAlign = subtitleTextAlign {
            subtitleLabel!.textAlignment = subtitleTextAlign
        }
        
        if titleFont != nil || subtitleFont != nil {
            updateBannerHeight()
        }
    }
    
}
