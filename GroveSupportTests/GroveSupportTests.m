//
//  GroveSupportTests.m
//  GroveSupportTests
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <GroveSupport/GroveSupport.h>

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

static NSString *globalUserName = @"TestAccount000";
static NSString *globalPassword = @"testpassword01";

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testUserFunctionality {
	
	[self setContinueAfterFailure:NO];
	
	[[GSGitHubEngine sharedInstance] authenticateUserWithUsername:globalUserName password:globalPassword completionHandler:^(GSUser * __nullable user, NSError * __nullable error) {
		if (error) {
			XCTAssertNil(error, "Couldn't properly auth. [%@]", error);
		}
		
		[[GSGitHubEngine sharedInstance] setActiveUser:user];
		
		[[GSGitHubEngine sharedInstance] eventsForUser:user completionHandler:^(id __nullable events, NSError * __nullable error) {
			NSLog(@"Events %@", events);
		}];
		
		//		[[GSCacheManager sharedInstance] findImageAssetWithURL:user.avatarURL loggedInUser:user downloadIfNecessary:YES completionHandler:^(UIImage *image, NSError *error) {
		//			NSLog(@"Image %p:%@", image, error);
		//		}];
		
		[[GSGitHubEngine sharedInstance] repositoriesStarredByUser:user completionHandler:^(NSArray * _Nullable repos, NSError * _Nullable error) {
			NSLog(@"Starred %@:%@", repos, error);
		}];
	}];
	
	// have to put locks around async methods so tests can actually finish
	
	dispatch_main();
	
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
