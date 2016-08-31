//
//  HorizontalTableView.m
//  TvRemote
//
//  Created by Danila Gusev on 29/02/2016.
//  Copyright © 2016 com.abrt. All rights reserved.
//

#import "EHHorizontalSelectionView.h"
#import "EHHorizontalViewCell.h"



@interface EHHorizontalSelectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end



@implementation NSBundle (ios7Bundle)

+ (instancetype)ios7Bundle{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *bundleUrl = [mainBundle URLForResource:@"EHHorizontalSelectionView" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    return bundle;
}

+ (UINib*)nibNamedPods:(NSString*)name{
    UINib *image;
    image = [UINib nibWithNibName:name bundle:nil];
    if (image) {
        return image;
    }
    
    image = [UINib nibWithNibName:[NSString stringWithFormat:@"EHHorizontalSelectionView.bundle/%@",name] bundle:nil];
    if (image) {
        return image;
    }
    NSBundle * b = [NSBundle ios7Bundle];
    NSData * data = [NSData dataWithContentsOfFile:[[b resourcePath] stringByAppendingPathComponent:name]];
    image = [UINib nibWithData:data bundle:b];
    
    return image;
}
@end


@implementation EHHorizontalSelectionView
{
    UICollectionView * _collectionView;
    UICollectionViewFlowLayout * _flowLayout;
    NSIndexPath * _selectedIndexPath;
    CGRect _lastCellRect;
    Class _class;
    NSUInteger _objectsCount;
    UINib * _nib;
}

#pragma mark - initializers
- (id)init
{
    self = [super init];
    if (self)
    {
        [self startView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self startView];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self startView];
    }
    return self;
}

#pragma mark - public
- (void)registerCellWithClass:(Class)class
{
    NSCAssert([class isSubclassOfClass:[EHHorizontalViewCell class]],  @"registerCellWithClass: received class that is not subclass of EHHorizontalViewCell class" );
    _class = class;
    [_collectionView registerClass:class forCellWithReuseIdentifier:[_class reuseIdentifier]];
}

- (void)registerCellNib:(UINib *)nib withClass:(Class)class
{
    NSCAssert([class isSubclassOfClass:[EHHorizontalViewCell class]],  @"registerCellNibWithName:withClass: received class that is not subclass of EHHorizontalViewCell class" );
    _class = class;
    [_collectionView registerNib:nib forCellWithReuseIdentifier:[_class reuseIdentifier]];
    _nib = nib;
}


- (NSUInteger)selectedIndex
{
    return _selectedIndexPath.row;
}

- (void)selectIndex:(NSUInteger)index
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - private
- (void)startView
{
    _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _flowLayout.minimumInteritemSpacing = 4.0f;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    _collectionView.clipsToBounds = NO;
    self.clipsToBounds = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    [_collectionView setAlwaysBounceHorizontal:YES];
    
    [self registerCellNib:[NSBundle nibNamedPods:@"EHHorizontalViewCell"] withClass:[EHHorizontalViewCell class]];
    
    [self addSubview:_collectionView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    
    [_collectionView reloadData];
    
}

#pragma mark - Collecton view methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    _objectsCount = MAX(0,[_delegate numberOfItemsInHorizontalSelection:self]);
    return _objectsCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGRect frame = collectionView.frame;

    NSString * name = [_delegate titleForItemAtIndex:indexPath.row forHorisontalSelection:self];

    if ([_class useDynamicSize])
    {
        UIFont * font = [_class font];
        float gap = [_class cellGap];
        
        CGSize strSize = [name sizeWithAttributes:@{NSFontAttributeName : font}];
        
        return CGSizeMake(strSize.width + gap, frame.size.height);
    }
    else
    {
        
        EHHorizontalViewCell * cell = [[_nib instantiateWithOwner:nil options:nil] lastObject];
        return cell.bounds.size;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    BOOL needCentred = NO;
    if ([_class isSubclassOfClass:[EHHorizontalViewCell class]])
    {
        needCentred = [_class needCentred];
    }
    if (needCentred)
    {
        float width = 0;
        for (int i = 0; i < _objectsCount; i++)
        {
            CGSize size = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
            width += size.width;
        }
        if (width < self.bounds.size.width)
            return UIEdgeInsetsMake(0, (self.bounds.size.width - width) / 2.0, 0, 0);
    }
    return UIEdgeInsetsZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EHHorizontalViewCell * cell = (EHHorizontalViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[_class reuseIdentifier] forIndexPath:indexPath];
    
    
    [cell setTitleLabelText:[_delegate titleForItemAtIndex:indexPath.row forHorisontalSelection:self]];

    cell.selectedCell = NO;
    if (_selectedIndexPath.row == indexPath.row)
    {
        _lastCellRect = cell.frame;
        cell.selectedCell = YES;
    }
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    EHHorizontalViewCell * cell = (EHHorizontalViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell highlight:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EHHorizontalViewCell * cell = (EHHorizontalViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell highlight:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EHHorizontalViewCell * oldCell = nil;
    if (_selectedIndexPath)
    {
        if (_selectedIndexPath.row < _objectsCount)
        {
            oldCell = (EHHorizontalViewCell*)[collectionView cellForItemAtIndexPath:_selectedIndexPath];
            oldCell.selectedCell = NO;
        }
    }
    
    EHHorizontalViewCell * newCell = (EHHorizontalViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    _selectedIndexPath = indexPath;
    
    if (_selectedIndexPath.row < _objectsCount)
    {
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [newCell setSelectedCell:YES fromCellRect:_lastCellRect];
        _lastCellRect = newCell.frame;
        
        if (_delegate && [_delegate respondsToSelector:@selector(horizontalSelection:didSelectObjectAtIndex:)])
        {
            [_delegate horizontalSelection:self didSelectObjectAtIndex:_selectedIndexPath.row];
        }
    }
}



@end