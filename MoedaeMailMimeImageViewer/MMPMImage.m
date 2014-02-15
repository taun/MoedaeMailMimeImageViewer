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

-(void) createSubviews {
    NSSize subStructureSize = self.frame.size;
    
    NSTextView* nodeView = [[MMPTextViewWithIntrinsic alloc] initWithFrame: NSMakeRect(0, 0, subStructureSize.width, subStructureSize.height)];
    // View in nib is min size. Therefore we can use nib dimensions as min when called from awakeFromNib
    [nodeView setMinSize: NSMakeSize(subStructureSize.width, subStructureSize.height)];
    [nodeView setMaxSize: NSMakeSize(FLT_MAX, FLT_MAX)];
    [nodeView setVerticallyResizable: YES];
    
    // No horizontal scroll version
    //    [rawMime setHorizontallyResizable: YES];
    //    [rawMime setAutoresizingMask: NSViewWidthSizable];
    //
    //    [[rawMime textContainer] setContainerSize: NSMakeSize(subStructureSize.width, FLT_MAX)];
    //    [[rawMime textContainer] setWidthTracksTextView: YES];
    
    // Horizontal resizable version
    [nodeView setHorizontallyResizable: YES];
    //    [rawMime setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
    
    [[nodeView textContainer] setContainerSize: NSMakeSize(FLT_MAX, FLT_MAX)];
    [[nodeView textContainer] setWidthTracksTextView: YES];
    //    [self addSubview: nodeView];
    
    //    [nodeView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    //    NSDictionary *views = NSDictionaryOfVariableBindings(self, rawMime);
    
    //    [self setContentCompressionResistancePriority: NSLayoutPriorityFittingSizeCompression-1 forOrientation: NSLayoutConstraintOrientationVertical];
    //NSLayoutPriorityDefaultHigh
    CGFloat borderWidth = 0.0;
    [nodeView setWantsLayer: YES];
    CALayer* rawLayer = nodeView.layer;
    [rawLayer setBorderWidth: borderWidth];
    [rawLayer setBorderColor: [[NSColor greenColor] CGColor]];
    
    
    CALayer* myLayer = self.layer;
    [myLayer setBorderWidth: borderWidth*2];
    [myLayer setBorderColor: [[NSColor redColor] CGColor]];
    
    self.mimeView = nodeView;
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self.mimeView selector: @selector(viewFrameChanged:) name: NSViewFrameDidChangeNotification object: self.mimeView];
    
    [self loadData];
    
    [super createSubviews];
}

@end
