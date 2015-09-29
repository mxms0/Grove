//
//  GroveSupportTests.m
//  GroveSupportTests
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GSGitHubEngine.h"
#import "GSCacheManager.h"

@interface GroveSupportTests : XCTestCase

@end

@implementation GroveSupportTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

static NSString *globalUserName = @"Maximus-";
static NSString *globalPassword = @"!Rocky&Hugo68";

- (void)testExample {
	
	[[GSGitHubEngine sharedInstance] authenticateUserWithUsername:globalUserName password:globalPassword completionHandler:^(GSUser * __nullable user, NSError * __nullable error) {
		if (error) {
			NSLog(@"error occured. %@", error);
		}
		
		[[GSGitHubEngine sharedInstance] eventsForUser:user completionHandler:^(id __nullable events, NSError * __nullable error) {
			NSLog(@"Events %@", events);
		}];
		
		[[GSCacheManager sharedInstance] findImageAssetWithURL:[NSURL URLWithString:@"https://avatars.githubusercontent.com/u/541239?"] loggedInUser:user downloadIfNecessary:YES completionHandler:^(UIImage *image, NSError *error) {
			NSLog(@"fds %p:%@", image, error);
		}];
	}];
	dispatch_main();
	
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
