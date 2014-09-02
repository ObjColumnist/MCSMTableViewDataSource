//
//  MCSMTableViewDataSourceObject.h
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 15/06/2014.
//  Copyright (c) 2014 Square Bracket Software. All rights reserved.
//

@import UIKit;

@interface MCSMTableViewDataSourceObject : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) id object;

@end
