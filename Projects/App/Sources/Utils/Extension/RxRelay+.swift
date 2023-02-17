//
//  Rx.swift
//  App
//
//  Created by Chanhee Jeong on 2023/02/17.
//  Copyright © 2023 com.promise8. All rights reserved.
//

import RxSwift
import RxRelay

extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    // USAGE: self.wishList.add(element: item.element)
    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
}
