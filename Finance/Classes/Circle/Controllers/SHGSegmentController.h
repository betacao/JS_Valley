/*!
 * \file MHTabBarController.h
 *
 * Copyright (c) 2011 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

@protocol SHGSegmentControllerDelegate;
typedef void(^loadViewFinishBlock)(UIView *view);
/*!
 * A custom tab bar container view controller. It works just like a regular
 * UITabBarController, except the tabs are at the top and look different.
 */
@interface SHGSegmentController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id <SHGSegmentControllerDelegate> delegate;
@property (nonatomic, copy) loadViewFinishBlock block;
@property (strong ,nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (strong ,nonatomic) UIBarButtonItem *leftBarButtonItem;

+ (instancetype)sharedSegmentController;
//刷新动态界面
- (void)refreshHomeView;
//简单的tableview刷新
- (void)reloadData;
//删除对象（只有动态界面才会有删除 已关注界面不存在删除）
- (void)removeObject:(CircleListObj *)object;
//通过rid查找对象 返回在动态界面和已关注界面的对象数组
- (NSArray *)targetObjectsByRid:(NSString *)string;
//通过userId查找对象 返回在动态界面和已关注界面的对象数组
- (NSArray *)targetObjectsByUserID:(NSString *)string;
//通过位置查找对象 只返回当前界面的对象
- (CircleListObj *)targetObjectByIndex:(NSInteger)index;
//查找对象在数组中的位置
- (NSArray *)indexOfObjectByRid:(NSString *)string;

//删除帖子号为rid的动态
- (void)deleteObjectByRid:(NSString *)rid;

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;

//消息界面的函数
- (void)setupUnreadMessageCount;
- (void)setupUntreatedApplyCount;
@end

/*!
 * The delegate protocol for MHTabBarController.
 */
@protocol SHGSegmentControllerDelegate <NSObject>
@optional
- (BOOL)SHG_SegmentController:(SHGSegmentController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)SHG_SegmentController:(SHGSegmentController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end
