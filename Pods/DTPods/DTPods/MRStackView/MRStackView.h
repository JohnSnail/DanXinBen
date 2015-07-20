//
//  MRStackView.h
//  MRStackView
//
//  Created by sheldon on 14-8-8.
//  Copyright (c) 2014年 wheelab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRStackViewCell;
@protocol MRStackViewDelegate;

@interface MRStackView : UIView <UIScrollViewDelegate>

@property (nonatomic) id<MRStackViewDelegate> delegate;

- (MRStackViewCell *)dequeueReusablePage;

@end

@protocol MRStackViewDelegate

- (MRStackViewCell *)stackView:(MRStackView *)stackView pageForIndex:(NSInteger)index;

- (NSInteger)numberOfPagesForStackView:(MRStackView *)stackView;

- (CGFloat)heightOfPagesForStackView:(MRStackView *)stackView;

- (void)stackView:(MRStackView *)stackView selectedPageAtIndex:(NSInteger)index;

- (UIViewController *)viewControllerForStackView:(MRStackView *)tackView selectedPageAtIndex:(NSInteger)index;

@end
