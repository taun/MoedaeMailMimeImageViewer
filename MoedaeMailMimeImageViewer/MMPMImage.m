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
    return [NSSet setWithObjects:@"IMAGE/JPEG",@"IMAGE/JPG",@"IMAGE/BMP",@"IMAGE/GIF", @"IMAGE/PNG", nil];
}

-(void) loadData {
    NSImage* messageImage;
    
    NSData* nsData = self.node.decoded;
    if (nsData) {
        messageImage = [[NSImage alloc] initWithData: nsData];
    } else {
        // todo: set messageImage to an image indicating no image.
        // maybe the ubiquitous red circle with a line through it.
    }

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
