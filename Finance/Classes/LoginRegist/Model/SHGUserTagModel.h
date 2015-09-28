//
//  SHGUserTagModel.h
//  Finance
//
//  Created by changxicao on 15/9/25.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "MTLModel.h"

@interface SHGUserTagModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *tagId;
@property (strong, nonatomic) NSString *tagName;

@end
