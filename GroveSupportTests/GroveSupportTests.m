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

@interface GroveSupportTests : XCTestCase {}
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
static GSUser *workingUser = nil;

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

#define GRTest(x, y) \
void (^x)(id self) = ^ void (id self) y;

#define GRRunTest(x) x(self);

// implicit self
GRTest(testRegistration, {
	
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
});

GRTest(testUserFunctionality, {
	
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
	
	//	[[GSCacheManager sharedInstance] findImageAssetWithURL:user.avatarURL loggedInUser:user downloadIfNecessary:YES completionHandler:^(UIImage *image, NSError *error) {
	//		NSLog(@"Image %p:%@", image, error);
	//	}];
	//
	//	[[GSGitHubEngine sharedInstance] repositoriesStarredByUser:user completionHandler:^(NSArray * _Nullable repos, NSError * _Nullable error) {
	//		NSLog(@"Starred %@:%@", repos, error);
	//	}];
	//
});

GRTest(testRepositoryFunctionality, {
	
});


GRTest(testCacheFunctionality, {
	
});

GRTest(testProjectFunctionality, {
	
});

- (void)test__lead {
	[self setContinueAfterFailure:NO];
	
	// may consider putting registration test inside setup
	// then letting tests go anywhere from there.
	// does it matter?
	
	GRRunTest(testRegistration);
	
	GRRunTest(testUserFunctionality);
	GRRunTest(testRepositoryFunctionality);
	GRRunTest(testCacheFunctionality);
	GRRunTest(testProjectFunctionality);
}

- (void)testPerformanceExample {
	[self measureBlock:^{}];
}

@end
