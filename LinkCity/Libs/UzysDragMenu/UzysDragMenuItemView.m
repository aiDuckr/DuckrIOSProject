//
//  UzysSMMenuView.m
//  UzysSlideMenu
//
//  Created by Jaehoon Jung on 13. 2. 21..
//  Copyright (c) 2013년 Uzys. All rights reserved.
//

#import "UzysDragMenuItemView.h"
#import "LCFilterTagButtonCell.h"
@interface UzysDragMenuItemView()<LCFilterTagButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) NSArray *inviteThemeArr;
@property (strong, nonatomic) NSArray *themeButtonArr;
@property(nonatomic)float keyBoardHeight;
@end

@implementation UzysDragMenuItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (CGSize)intrinsicContentSize {
    return CGSizeMake(DEVICE_WIDTH, self.collectionView.frame.size.height+self.textfield.frame.size.height+40.0f);
}

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}
- (void)initCollectionsView {
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([LCFilterTagButtonCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([LCFilterTagButtonCell class])];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.estimatedItemSize = CGSizeMake(78.0f, 30.0f);
    self.collectionView.collectionViewLayout = layout;
}


#pragma mark - LCFilterTagButton Delegate.
- (void)filterTagButtonSelected:(LCFilterTagButton *)button {
       if (NSNotFound != [self.themeButtonArr indexOfObject:button]) {
        [button updateShowButtons:self.themeButtonArr];
    }
    [self inviteDidFitler];
}
- (void)inviteDidFitler {
    if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(ItemdidSelectedThemeID:)]) {
        for (LCFilterTagButton *btn in self.themeButtonArr) {
            if (YES == btn.selected) {
//                self.fitlerThemeId = btn.tag;
                [self.itemDelegate ItemdidSelectedThemeID:btn.tag];
                break ;
            }
        }
    }
}

#pragma mark - UICollectionView Delegate.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0f;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (nil != self.inviteThemeArr) {
        num = self.inviteThemeArr.count;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCFilterTagButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LCFilterTagButtonCell class]) forIndexPath:indexPath];
    if (nil != self.inviteThemeArr) {
        LCRouteThemeModel *model = [self.inviteThemeArr objectAtIndex:indexPath.row];
        [cell updateFilterTagButton:model];
        if (NSNotFound == [self.themeButtonArr indexOfObject:cell.filterTagButton]) {
            NSMutableArray *mutArr = [[NSMutableArray alloc] initWithArray:self.themeButtonArr];
            [mutArr addObject:cell.filterTagButton];
            self.themeButtonArr = mutArr;
        }
        if (0 == model.tourThemeId) {
            [cell.filterTagButton updateFilterTagButtonStatus:YES];
        }
        cell.filterTagButton.type = FilterTagButtonType_Radio;
        cell.filterTagButton.delegate = self;
    }
    return cell;
}


- (void)dealloc {
//    [_backgroundView release];
//    [super ah_dealloc];
}

#pragma mark - using gestureRecognizer
-(void)awakeFromNib
{
    [super awakeFromNib];
      self.themeButtonArr = [[NSArray alloc] init];
    [self initCollectionsView];
    self.inviteThemeArr=[LCDataManager sharedInstance].appInitData.inviteThemes;

    [self intrinsicContentSize];
    NSLog(@"%f" ,self.bounds.size.width);
    
    [self.collectionView reloadData];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    self.textfield.delegate=self;
    [self registerForKeyboardNotifications];
}
#pragma mark - UITextField Delegate.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{

    return YES;
}
//已经开始编辑的时候 会触发这个方法—
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

//结束编辑的时候调用

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

//点击Return键的时候，（标志着编辑已经结束了）
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    NSLog(@"%@",textField.text);
    [textField resignFirstResponder];
    if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(changeViewForTextField:)]) {//调整高度
        [self.itemDelegate changeViewForTextField:0.0f];
    }
    if(self.textfield.text.length>0){
        if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(ItemdidSelectedThemeStr:)])
            [self.itemDelegate ItemdidSelectedThemeStr:self.textfield.text];
    }
    return YES;
}
#pragma mark Keyboards
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification {

}
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    self.keyBoardHeight = kbSize.height;
    NSLog(@"%f",self.keyBoardHeight);
    
    if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(changeViewForTextField:)]) {//调整高度
                [self.itemDelegate changeViewForTextField:self.keyBoardHeight];
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(changeViewForTextField:)]) {//调整高度
//        [self.itemDelegate changeViewForTextField:0.0f];
//    }
//    if(self.textfield.text.length>0){
//        if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(ItemdidSelectedThemeStr:)])
//            [self.itemDelegate ItemdidSelectedThemeStr:self.textfield.text];
//    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

@end
