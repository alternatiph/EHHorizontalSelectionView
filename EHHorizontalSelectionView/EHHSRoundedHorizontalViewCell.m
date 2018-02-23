//
//  PinkHorizontalViewCell.m
//  TvRemote
//
//  Created by Danila Gusev on 01/03/2016.
//  Copyright © 2016 com.abrt. All rights reserved.
//

#import "EHHSRoundedHorizontalViewCell.h"
#import "EHHorizontalViewCell.h"

@implementation EHHSRoundedHorizontalViewCell

- (void)awakeFromNib {
    self.titleLabel.font = [EHHSRoundedHorizontalViewCell font];
    [super awakeFromNib];
    // Initialization code
}

+ (NSMutableDictionary *)styles
{
    NSMutableDictionary * retDict = [super styles];
    [retDict setObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0] forKey:@"fontMedium"];
    [retDict setObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0] forKey:@"font"];
    [retDict setObject:@(48) forKey:@"cellGap"];
    [retDict setObject:@(NO) forKey:@"needCentered"];
    [retDict setObject:[UIColor colorWithRed:85.0/255.0 green:30.0/255.0 blue:140.0/255.0 alpha:1.0] forKey:@"altTextColor"];
    [retDict setObject:[UIColor whiteColor] forKey:@"textColor"];
    return retDict;
}

- (void)setTitleLabelText:(NSString *)text
{
    self.titleLabel.text = text;
}


- (UIView *)createSelectedView
{
    self.clipsToBounds = NO;
    self.coloredView.frame = CGRectMake(0, _EHDefaultGap * 1.2, self.bounds.size.width, self.bounds.size.height - _EHDefaultGap * 2.4);
    self.coloredView.layer.cornerRadius = 6.0;
    self.coloredView.layer.masksToBounds = NO;
    self.selectedView.clipsToBounds = NO;
    [self.coloredView setBackgroundColor:[UIColor colorWithRed:85.0/255.0 green:30.0/255.0 blue:140.0/255.0 alpha:1.0]];
    self.coloredView.layer.shadowColor = [[UIColor colorWithRed:85.0/255.0 green:30.0/255.0 blue:140.0/255.0 alpha:0.4] CGColor];
    self.coloredView.layer.shadowRadius = 4.0;
    self.coloredView.layer.masksToBounds = false;
    self.coloredView.layer.shadowOpacity = 1.0;
    self.coloredView.layer.shadowOffset = CGSizeMake(0, 0);
    
    
    
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView * tLabel = self.titleLabel;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tLabel)]];
    
    [self updateSelectedFrames];
    return self.selectedView;
}


- (void)updateConstraints
{
    [super updateConstraints];
    [self updateSelectedFrames];
}

- (void)updateSelectedFrames
{
    self.titleLabel.frame = self.bounds;
    self.selectedView.frame = self.bounds;
    self.coloredView.frame = CGRectMake( 0, _EHDefaultGap * 1.2, self.bounds.size.width, self.bounds.size.height - _EHDefaultGap * 2.4);
    self.coloredView.layer.cornerRadius = 6.0;
}

- (void)updateFramesForMovingFromRect:(CGRect)rect
{
    self.selectedView.frame = CGRectMake(CGRectGetMinX(rect) - CGRectGetMinX(self.frame), 0, rect.size.width, self.selectedView.bounds.size.height);
    self.coloredView.frame = CGRectMake(0 , _EHDefaultGap, self.selectedView.bounds.size.width , self.selectedView.bounds.size.height - _EHDefaultGap * 2);
    self.coloredView.layer.cornerRadius = 6.0;
}
@end
