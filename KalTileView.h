/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

// these values correspond to values in the KalTileStateMode mask
#define kKalTileTypeRegular  (0 << 16)
#define kKalTileTypeAdjacent (1 << 16)
#define kKalTileTypeToday    (2 << 16)

#define kKalTileMarked (0x4 << 16)

// The KalTileView's state is encoded in the UIControlEventApplicationReserved
// part of the UIControl state.
enum {
  KalTileStateMode       = 0x03 << 16,  // bits 0 and 1 encode the tile mode (regular, adjacent, today)
  KalTileStateMarked     = 0x04 << 16   // bit 2 is true when there is data attached to this tile's date.
};
typedef UIControlState KalTileState;

/*
 *    KalTileView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalGridView).
 *
 *  A KalTileView represents a single day of the month on the calendar.
 */
@interface KalTileView : UIControl
{
  NSDate *date;
  UILabel *dayLabel;
  UIImageView *backgroundView;
  UIImageView *markerView;
  KalTileState state;
}

@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) NSDate *date;         // The date that this tile represents.
@property (nonatomic, retain) UILabel *dayLabel;    // Displays the day number for this tile.
@property (nonatomic) BOOL belongsToAdjacentMonth;  // YES if the tile is part of a partial week from an adjacent month (such tiles are grayed out, just like in Apple's mobile calendar app)
@property (nonatomic) BOOL marked;                  // YES if the tile should draw a marker underneath the day number. (the mark indicates to the user that the tile's date has one or more associated events)

- (void)prepareForReuse;                            // KalGridView manages a pool of reusable KalTileViews. This method behaves like the prepareForReuse method on the UITableViewCell class.

@end
