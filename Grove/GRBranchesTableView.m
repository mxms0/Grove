//
//  GRBranchesTableView.m
//  Grove
//
//  Created by Rocco Del Priore on 11/10/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRBranchesTableView.h"

@interface GRBranchesTableView ()
@property (nonatomic) UINavigationController *navigationController;
@end

@implementation GRBranchesTableView

- (instancetype)initWithModel:(id<GRDataSource>)model
         navigationController:(UINavigationController *)navigationController {
    self = [super initWithModel:model];
    if (self) {
        self.navigationController = navigationController;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.model respondsToSelector:@selector(modelObjectForIndexPath:)]) {
        
    }
    NSLog(@"didSelectRowAtIndexPath pushing VC");
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor purpleColor];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
