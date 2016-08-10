//
//  GSGitHubEngineInternal.h
//  GroveSupport
//
//  Created by Max Shavrick on 11/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef GSGitHubEngineInternal_h
#define GSGitHubEngineInternal_h

#import "GSGitHubEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSGitHubEngine ()

- (void)_dirtyRequestWithObject:(GSObject *)obj completionHandler:(void (^)(NSDictionary *__nullable ret, NSError *__nullable error))handler;
- (void)_userInformationForUsername:(NSString *)username completionHandler:(void (^)(NSDictionary *__nullable info, NSError *__nullable error))handler;
@end

NS_ASSUME_NONNULL_END

#define GSInsuranceBegin(obj,type,error) { \
	Class __gs_c = [type class]; \
	id __gs_obj = obj; \
	NSError *__gs_error = error;

#define GSInsuranceError if (__gs_error)
#define GSInsuranceBadData else if (!__gs_obj || ![__gs_obj isKindOfClass:__gs_c]) 
#define GSInsuranceGoodData else

#define GSInsuranceEnd() }

#endif /* GSGitHubEngineInternal_h */
