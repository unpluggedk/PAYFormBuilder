//
//  PAYFormTextField.m
//  paij
//
//  Created by Marius Rackwitz on 14.11.13.
//  Copyright (c) 2013 redpixtec. GmbH. All rights reserved.
//

#import "PAYFormTextField.h"
#import "NSError+PAYComfort.h"


@interface PAYFormTextField ()

@end


@implementation PAYFormTextField

- (void)setEnabled:(BOOL)enabled {
}


#pragma mark - Style text field

- (void)styleViewsForErroneousState:(BOOL)hasError {
}

#pragma mark - Custom validation

- (NSError *)prevalidate {
    NSError *error = [super prevalidate];
    if (error) {
        return error;
    }
    
    NSString *cleanedValue = self.cleanedValue;
    
    if (self.maxTextLength > 0 && cleanedValue.length > self.maxTextLength) {
        return [NSError validationErrorWithCode:PAYFormTextFieldAboveMaxLength control:self];
    }
    
    if (self.minTextLength > 0 && cleanedValue.length < self.minTextLength) {
        return [NSError validationErrorWithCode:PAYFormTextFieldBelowMinLength control:self];
    }
    
    return nil;
}

- (BOOL)isEmpty {
    return ((NSString *)self.cleanedValue).length == 0;
}

#pragma mark - Format block

- (void)setFormatTextWithGroupSizes:(NSArray *)groupSizes {
    [self setFormatTextWithGroupSizes:groupSizes separator:nil];
}

- (void)setFormatTextWithGroupSizes:(NSArray *)groupSizes separator:(NSString *)separator {
    self.formatBlock = [self formatBlockWithGroupSizes:groupSizes separator:separator];
}

- (PAYFormFieldFormatBlock)formatBlockWithGroupSizes:(NSArray *)groupSizes separator:(NSString *)separator {
    if (!separator) {
        separator = @" ";
    }
    return ^(PAYFormField *field, NSString *text){
        NSMutableArray* numberGroups = [NSMutableArray new];
        int groupSize=0, groupIndex=0;
        for (int i=0; i<text.length; i+=groupSize) {
            groupSize = [groupSizes[groupIndex++] intValue];
            [numberGroups addObject:[text substringWithRange:NSMakeRange(i, MIN(groupSize, text.length-i))]];
        }
        return [numberGroups componentsJoinedByString:separator];
    };
}

@end