/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

@class KalTileView, KalLogic;
@protocol KalViewDelegate;

/*
 *    KalGridView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalView).
 *
 *  Each |cell| is a UIView, and each cell's width is the full width of the KalGridView.
 *  In other words, the cell represents a week in the calendar.
 *  One cell (week) can optionally be kept on-screen by the slide animation, depending
 *  on whether the currently selected month has a partial week that belongs to the month
 *  that will be slid into place.
 */
@interface KalGridView : UIView
{
  id<KalViewDelegate> delegate;  // Assigned.
  KalLogic *logic;
  KalTileView *selectedTile;
  KalTileView *highlightedTile;
  NSMutableArray *reusableCells;        // The pool of reusable cells. If this runs out, the app will crash instead of dynamically allocating more views. So make this just large enough to meet your app needs, but no larger.
  CGFloat cellHeight;                   // Every cell must have the same height: specifically, the height stored here.
}

@property (nonatomic, retain) KalTileView *selectedTile;
@property (nonatomic, retain) KalTileView *highlightedTile;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalViewDelegate>)delegate;

- (void)refresh;

// These 2 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)slideUp;
- (void)slideDown;

@end
