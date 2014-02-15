//
//  MMPMImage.m
//  MoedaeMailMimeImageViewer
//
//  Created by Taun Chapman on 02/13/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "MMPMImage.h"

@implementation MMPMImage

+(NSSet*) contentTypes {
    return [NSSet setWithObjects:@"IMAGE/JPEG",@"IMAGE/GIF", @"IMAGE/PNG", nil];
}

-(void) loadData {
    NSData* nsData = self.node.decoded;
    NSImage* messageImage = [[NSImage alloc] initWithData: nsData];
    NSTextAttachmentCell *anAttachmentCell = [[NSTextAttachmentCell
                                               alloc] initImageCell: messageImage];
    
    //[anAttachmentCell setTitle: self.name];
    
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    
    [attachment setAttachmentCell: anAttachmentCell];
    [attachment.fileWrapper setPreferredFilename: self.node.name];
    
    NSAttributedString* subComposition = [NSAttributedString attributedStringWithAttachment: attachment];
    [[(NSTextView*)(self.mimeView) textStorage] setAttributedString: subComposition];
    [self setNeedsUpdateConstraints: YES];
}

@end
