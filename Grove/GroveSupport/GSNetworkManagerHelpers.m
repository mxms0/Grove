//
//  GSNetworkManagerHelpers.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSNetworkManagerHelpers.h"

NSString *GSHTTPVerbStringForVerb(GSAPIHTTPVerb verb) {
	NSString *ret = nil;
	switch (verb) {
		case GSAPIHTTPVerbHead:
			ret = @"HEAD";
			break;
		case GSAPIHTTPVerbGet:
			ret = @"GET";
			break;
		case GSAPIHTTPVerbPost:
			ret = @"POST";
			break;
		case GSAPIHTTPVerbPatch:
			ret = @"PATCH";
			break;
		case GSAPIHTTPVerbPut:
			ret = @"PUT";
			break;
		case GSAPIHTTPVerbDelete:
			ret = @"DELETE";
			break;
		default:
			GSAssert();
			ret = @"UNKNOWN";
			break;
	}
	return ret;
}

NSURL *GSAPIURLComplex(NSString *endp, ...) {
	NSURL *base = GSAPIURLForEndpoint(endp);
	
	va_list ap;
	va_start(ap, endp);
	id pathComponent;
	while ((pathComponent = va_arg(ap, id))) {
		if (pathComponent) {
			base = [base URLByAppendingPathComponent:pathComponent];
		}
	}
	
	va_end(ap);
	
	return base;
}

NSURL *GSAPIURLForEndpoint(NSString *endp) {
	return [[NSURL URLWithString:GSAPIHostURL] URLByAppendingPathComponent:endp];
}
