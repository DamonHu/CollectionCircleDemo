//
//  ViewController.m
//  CollectionCircleDemo
//
//  Created by Damon on 2017/5/24.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "JLXUICollectionViewFlowLayout.h"
#import "HomeCaseCell.h"

static NSString * const reuseIdentifier = @"HomeCaseCellID";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *caseArray;
@property (assign,nonatomic) NSInteger m_currentIndex;
@property (assign,nonatomic) CGFloat m_dragStartX;
@property (assign,nonatomic) CGFloat m_dragEndX;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadData];
}

-(void)createUI{
    JLXUICollectionViewFlowLayout *layout = [[JLXUICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(474*kJLXWidthScale, 848*kJLXHeightScale);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 50*kJLXWidthScale;
    layout.minimumInteritemSpacing = 50*kJLXWidthScale;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:kJLXBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[HomeCaseCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];

    [self.collectionView setFrame:CGRectMake(0, 40*kJLXHeightScale, JLXScreenSize.width, JLXScreenSize.height)];
    self.collectionView.contentSize = CGSizeMake(self.caseArray.count*JLXScreenSize.width, 0);
}

-(void)loadData{
    NSArray *array = [NSArray arrayWithObjects:@"img1",@"img2",@"img3",@"img4", nil];
    self.caseArray = [NSMutableArray array];
    ///加四次为了循环
    for (int i=0; i<4; i++) {
        [self.caseArray addObjectsFromArray:array];
    }
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.caseArray.count/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.m_currentIndex = self.caseArray.count/2;
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.view.bounds.size.width/20.0f;
    if (self.m_dragStartX -  self.m_dragEndX >= dragMiniDistance) {
        self.m_currentIndex -= 1;//向右
    }else if(self.m_dragEndX -  self.m_dragStartX >= dragMiniDistance){
        self.m_currentIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    
    
    self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
    self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
    
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.caseArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //自定义item的UIEdgeInsets
    return UIEdgeInsetsMake(0, self.view.bounds.size.width/2.0-474*kJLXWidthScale/2, 0, self.view.bounds.size.width/2.0-474*kJLXWidthScale/2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.coverImgView setImage:[UIImage imageNamed:[self.caseArray objectAtIndex:indexPath.item]]];
    
    return cell;
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.m_dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.m_dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.m_currentIndex == [self.caseArray count]/4*3) {
        NSIndexPath *path  = [NSIndexPath indexPathForItem:[self.caseArray count]/2 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.m_currentIndex = [self.caseArray count]/2;
    }
    else if(self.m_currentIndex == [self.caseArray count]/4){
        NSIndexPath *path = [NSIndexPath indexPathForItem:[self.caseArray count]/2 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.m_currentIndex = [self.caseArray count]/2;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
