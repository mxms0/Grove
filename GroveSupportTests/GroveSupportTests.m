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

@interface GroveSupportTests : XCTestCase {
	GSUser *workingUser;
}

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

- (void)waitWithWait:(dispatch_semaphore_t)wait {
	while (dispatch_semaphore_wait(wait, DISPATCH_TIME_NOW)) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
	}
	
}

#define GenericFetchNotNilFail(arg) \
	do { \
		XCTAssertNotNil(arg, @"Couldn't fetch "@#arg); \
	} while (0);

#define GenericFetchNilFail(arg) \
	do { \
		XCTAssertNil(arg, @"Couldn't fetch "@#arg); \
	} while (0);



- (void)testA {
	
	[self setContinueAfterFailure:NO];
	
	__block GSUser *tmpUser = nil;
	
	dispatch_semaphore_t wait = dispatch_semaphore_create(0);
	
	[[GSGitHubEngine sharedInstance] authenticateUserWithUsername:globalUserName password:globalPassword completionHandler:^(GSUser * __nullable user, NSError * __nullable error) {
		tmpUser = user;
		
		GenericFetchNotNilFail(user);
		
		dispatch_semaphore_signal(wait);
	}];
	
	[self waitWithWait:wait];
	
	[[GSGitHubEngine sharedInstance] setActiveUser:workingUser];
	
	workingUser = tmpUser;
	
	// hey hopefully this runs early.
}

- (void)testUserFunctionality {
	
	[self setContinueAfterFailure:NO];
	
	[[GSGitHubEngine sharedInstance] eventsForUser:workingUser completionHandler:^(id __nullable events, NSError * __nullable error) {
		GenericFetchNotNilFail(events);
		GenericFetchNilFail(error);
		NSLog(@"Events %@", events);
	}];
	
	[[GSGitHubEngine sharedInstance] repositoriesForUser:workingUser completionHandler:^(NSArray<GSRepository *> * _Nullable repos, NSError * _Nullable error) {
		GenericFetchNilFail(error);
		GenericFetchNotNilFail(repos);
		NSLog(@"Repositories %@", repos);
	}];
	
	
//
//		//		[[GSCacheManager sharedInstance] findImageAssetWithURL:user.avatarURL loggedInUser:user downloadIfNecessary:YES completionHandler:^(UIImage *image, NSError *error) {
//		//			NSLog(@"Image %p:%@", image, error);
//		//		}];
//		
//		[[GSGitHubEngine sharedInstance] repositoriesStarredByUser:user completionHandler:^(NSArray * _Nullable repos, NSError * _Nullable error) {
//			NSLog(@"Starred %@:%@", repos, error);
//		}];
//	
	
	// have to put locks around async methods so tests can actually finish
	
//	dispatch_main();
	
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
