//
//  GSGitHubEngine+Projects.m
//  Grove
//
//  Created by Jim Boulter on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSProjectGitHubEngine.h"

@implementation GSGitHubEngine (GSProjectGitHubEngine)

- (void) projectsForUser:(GSUser* __nullable)user completionHandler:(void (^ __nullable) (NSArray* __nullable))handler {
	
}

// GET /repos/:owner/:repo/projects/:number
- (void) projectInRepository:(GSRepository* __nullable)repo withNumber:(int)number completionHandler:(void (^ __nullable) (GSProject* __nullable))handler {
	
}

// GET /repos/:owner/:repo/projects/:project_number/columns
- (void) columnsForProject:(GSProject* __nullable)project completionHandler:(void (^ __nullable) (NSArray* __nullable))handler {
	
}

@end
