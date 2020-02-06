//
//  RxKeyboardHelper.swift
//  FlickrSearch
//
//  Created by Chris Karani on 05/02/2020.
//  Copyright © 2020 Chris Karani. All rights reserved.
//




import RxSwift
import RxCocoa
import UIKit



import RxSwift
import RxCocoa 
func keyboardHeight() -> Observable<CGFloat> {
    return Observable
            .from([
                NotificationCenter.default.rx.notification(UIResponder.keyboardDidShowNotification)
                            .map { notification -> CGFloat in
                                let userInfo = notification.userInfo
                                print(userInfo!)
                                return (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
                                
                            },
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                            .map { notification -> CGFloat in
                                 let userInfo = notification.userInfo
                                print(userInfo)
                                return (userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
                            }
            ])
            .merge()
}
