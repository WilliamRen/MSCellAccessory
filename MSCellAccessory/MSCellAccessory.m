//
//  MSCellAccessory.m
//  MSCellAccessory
//
//  Created by SHIM MIN SEOK on 13. 6. 19..
//  Copyright (c) 2013 SHIM MIN SEOK. All rights reserved.
//

#import "MSCellAccessory.h"

#define kAccessoryViewRect              CGRectMake(0, 0, 32.0, 32.0)

#define kCircleRect                     CGRectMake(5.5, 3.5, 22.0, 22.0)
#define kCircleOverlayRect              CGRectMake(3.5, 14.5, 23.0, 23.0)
#define kStrokeWidth                    2.0
#define kShadowRadius                   4.6
#define kShadowOffset                   CGSizeMake(.08, .52)
#define kShadowColor                    [UIColor colorWithWhite:.0 alpha:1.]
#define kDetailDisclosurePositon        CGPointMake(20.0, 14.5)
#define kDetailDisclosureRadius         5.5
#define kHighlightedColorGapH           9.0/360.0
#define kHighlightedColorGapS           9.5/100.0
#define kHighlightedFlatColorGapS       80.0/100.0
#define kHighlightedColorGapV          -4.5/100.0
#define kOverlayColorGapH               0.0/360.0
#define kOverlayColorGapS              -50.0/255.0
#define kOverlayColorGapV               15.0/255.0

#define kDisclosureStartX               CGRectGetMaxX(self.bounds)-7.0
#define kDisclosureStartY               CGRectGetMidY(self.bounds)
#define kDisclosureRadius               4.5
#define kDisclosureWidth                3.0
#define kDisclosureShadowOffset         CGSizeMake(.0, -1.0)
#define kDisclosurePositon              CGPointMake(18.0, 13.5)

#define kCheckMarkStartX                kAccessoryViewRect.size.width/2 + 1
#define kCheckMarkStartY                kAccessoryViewRect.size.height/2 - 1
#define kCheckMarkLCGapX                3.5
#define kCheckMarkLCGapY                5.0
#define kCheckMarkCRGapX                10.0
#define kCheckMarkCRGapY                -6.0
#define kCheckMarkWidth                 2.5

#define kToggleIndicatorStartX          CGRectGetMaxX(self.bounds)-10.0
#define kToggleIndicatorStartY          CGRectGetMidY(self.bounds)
#define kToggleIndicatorRadius          5.5
#define kToggleIndicatorLineWidth       3.5

#define FLAT_ACCESSORY_VIEW_RECT                            CGRectMake(0, 0, 52.0, 32.0)
#define FLAT_STROKE_WIDTH                                   1.0
#define FLAT_DETAIL_CIRCLE_RECT                             CGRectMake(10.5, 5.5, 21.0, 21.0)
#define FLAT_DETAIL_BUTTON_DOT_FRAME                        CGRectMake(19.6, 9.5, 2.6, 2.6)
#define FLAT_DETAIL_BUTTON_VERTICAL_WIDTH                   2.0
#define FLAT_DETAIL_BUTTON_VERTICAL_START_POINT             CGPointMake(21, 13.5)
#define FLAT_DETAIL_BUTTON_VERTICAL_END_POINT               CGPointMake(21, 21.5)
#define FLAT_DETAIL_BUTTON_HORIZONTAL_WIDTH                 0.5
#define FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_START_POINT       CGPointMake(19.0, 13.5 + FLAT_DETAIL_BUTTON_HORIZONTAL_WIDTH * 0.5)
#define FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_END_POINT         CGPointMake(21.0, 13.5 + FLAT_DETAIL_BUTTON_HORIZONTAL_WIDTH * 0.5)
#define FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_START_POINT    CGPointMake(19.0, 21.5 + FLAT_DETAIL_BUTTON_HORIZONTAL_WIDTH * 0.5)
#define FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_END_POINT      CGPointMake(23.0, 21.5 + FLAT_DETAIL_BUTTON_HORIZONTAL_WIDTH * 0.5)

#define FLAT_DISCLOSURE_START_X                             CGRectGetMaxX(self.bounds)-1.5
#define FLAT_DISCLOSURE_START_Y                             CGRectGetMidY(self.bounds)+0.25
#define FLAT_DISCLOSURE_RADIUS                              4.8
#define FLAT_DISCLOSURE_WIDTH                               2.2
#define FLAT_DISCLOSURE_SHADOW_OFFSET                       CGSizeMake(.0, -1.0)
#define FLAT_DISCLOSURE_POSITON                             CGPointMake(18.0, 13.5)

#define FLAT_CHECKMARK_START_X                              kAccessoryViewRect.size.width/2 + 4.25
#define FLAT_CHECKMARK_START_Y                              kAccessoryViewRect.size.height/2 + 1.25
#define FLAT_CHECKMARK_LC_GAP_X                             2.5
#define FLAT_CHECKMARK_LC_GAP_Y                             2.5
#define FLAT_CHECKMARK_CR_GAP_X                             9.875
#define FLAT_CHECKMARK_CR_GAP_Y                             -4.375
#define FLAT_CHECKMARK_WIDTH                                2.125

#define FLAT_TOGGLE_INDICATOR_START_X                       CGRectGetMaxX(self.bounds)-7.0
#define FLAT_TOGGLE_INDICATOR_START_Y                       CGRectGetMidY(self.bounds)
#define FLAT_TOGGLE_INDICATOR_RADIUS                        5.0
#define FLAT_TOGGLE_INDICATOR_LINE_WIDTH                    2.0


@interface MSCellAccessory()
@property (nonatomic, assign) AccessoryType type;
@property (nonatomic, strong) UIColor *accessoryColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, strong) NSArray *accessoryColors;
@property (nonatomic, strong) NSArray *highlightedColors;
@end

@implementation MSCellAccessory

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(_type == FLAT_DETAIL_BUTTON)
    {
        if(point.x > 0)
            return YES;
    }
    else if(_type == FLAT_DETAIL_DISCLOSURE)
    {
        if(point.x > -3 && point.x < 46)
            return YES;
    }
    
    return [super pointInside:point withEvent:event];
}

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor accType:(AccessoryType)accType
{
    if ((self = [super initWithFrame:frame]))
    {
		self.backgroundColor = [UIColor clearColor];
        self.accessoryColor = color;
        self.type = accType;

        if(!highlightedColor)
        {
            if(_type >= FLAT_DETAIL_DISCLOSURE)
            {
                if(_type == FLAT_DETAIL_BUTTON)
                {
                    CGFloat h,s,v,a;
                    [_accessoryColor getHue:&h saturation:&s brightness:&v alpha:&a];
                    self.highlightedColor = [UIColor colorWithHue:h saturation:s-kHighlightedFlatColorGapS brightness:v alpha:a];
                }
                else
                {
                    self.highlightedColor = self.accessoryColor;
                }
            }
            else
            {
                CGFloat h,s,v,a;
                [_accessoryColor getHue:&h saturation:&s brightness:&v alpha:&a];
                self.highlightedColor = [UIColor colorWithHue:h+kHighlightedColorGapH saturation:s+kHighlightedColorGapS brightness:v+kHighlightedColorGapV alpha:a];
            }
        }
        else
        {
            self.highlightedColor = highlightedColor;
        }
        
        self.userInteractionEnabled = NO;
        if(_type == DETAIL_DISCLOSURE || _type == FLAT_DETAIL_BUTTON)
            self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame colors:(NSArray *)colors highlightedColors:(NSArray *)highlightedColors accType:(AccessoryType)accType
{
    if ((self = [super initWithFrame:frame]))
    {
		self.backgroundColor = [UIColor clearColor];
        self.accessoryColors = colors;
        self.type = accType;
        if(!highlightedColors)
        {
            CGFloat h,s,v,a;
            [colors[0] getHue:&h saturation:&s brightness:&v alpha:&a];
            self.highlightedColors = @[[UIColor colorWithHue:h saturation:s-kHighlightedFlatColorGapS brightness:v alpha:a],colors[1]];
        }
        else
        {
            self.highlightedColors = highlightedColors;
        }
    }
    
    return self;
}

+ (MSCellAccessory *)accessoryWithType:(AccessoryType)accType color:(UIColor *)color
{
    return [self accessoryWithType:accType color:color highlightedColor:NULL];
}

+ (MSCellAccessory *)accessoryWithType:(AccessoryType)accType color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor
{
    return [[MSCellAccessory alloc] initWithFrame:kAccessoryViewRect color:color highlightedColor:highlightedColor accType:accType];
}

+ (MSCellAccessory *)accessoryWithType:(AccessoryType)accType colors:(NSArray *)colors
{
    if(accType != FLAT_DETAIL_DISCLOSURE)
        return [self accessoryWithType:accType color:colors[0]];
    
    return [self accessoryWithType:accType colors:colors highlightedColors:NULL];
}

+ (MSCellAccessory *)accessoryWithType:(AccessoryType)accType colors:(NSArray *)colors highlightedColors:(NSArray *)highlightedColors
{
    if(accType != FLAT_DETAIL_DISCLOSURE)
        return [self accessoryWithType:accType color:colors[0] highlightedColor:highlightedColors[0]];

    return [[MSCellAccessory alloc] initWithFrame:FLAT_ACCESSORY_VIEW_RECT colors:colors highlightedColors:highlightedColors accType:accType];
}


- (void)drawRect:(CGRect)rect
{
    if(_type == DETAIL_DISCLOSURE)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIBezierPath *markCircle = [UIBezierPath bezierPathWithOvalInRect:kCircleRect];
        
        CGContextSaveGState(ctx);
        {
            CGContextAddPath(ctx, markCircle.CGPath);
            CGFloat h,s,v,a;
            UIColor *color = NULL;
            color = self.touchInside?_highlightedColor:_accessoryColor;
            [color getHue:&h saturation:&s brightness:&v alpha:&a];
            UIColor *overlayColor = [UIColor colorWithHue:h saturation:s+kOverlayColorGapS brightness:v+kOverlayColorGapV alpha:a];
            CGContextSetFillColorWithColor(ctx, overlayColor.CGColor);
            CGContextSetShadowWithColor(ctx, kShadowOffset, kShadowRadius, kShadowColor.CGColor );
            CGContextDrawPath(ctx, kCGPathFill);
        }
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        {
            CGContextAddPath(ctx, markCircle.CGPath);
            CGContextClip(ctx);
            CGContextAddRect(ctx, kCircleOverlayRect);
            CGContextSetFillColorWithColor(ctx, self.touchInside?_highlightedColor.CGColor:_accessoryColor.CGColor);
            CGContextDrawPath(ctx, kCGPathFill);
        }
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        {
            CGContextAddPath(ctx, markCircle.CGPath);
            CGContextSetLineWidth(ctx, kStrokeWidth);
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextDrawPath(ctx, kCGPathStroke);
        }
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        {
            CGContextSetShadowWithColor(ctx, kDisclosureShadowOffset, .0, self.touchInside?_highlightedColor.CGColor:_accessoryColor.CGColor);
            CGContextMoveToPoint(ctx, kDetailDisclosurePositon.x-kDetailDisclosureRadius, kDetailDisclosurePositon.y-kDetailDisclosureRadius);
            CGContextAddLineToPoint(ctx, kDetailDisclosurePositon.x, kDetailDisclosurePositon.y);
            CGContextAddLineToPoint(ctx, kDetailDisclosurePositon.x-kDetailDisclosureRadius, kDetailDisclosurePositon.y+kDetailDisclosureRadius);
            CGContextSetLineWidth(ctx, kDisclosureWidth);
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
    }
    else if(_type == DISCLOSURE_INDICATOR)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctx, kDisclosureStartX-kDisclosureRadius, kDisclosureStartY-kDisclosureRadius);
        CGContextAddLineToPoint(ctx, kDisclosureStartX, kDisclosureStartY);
        CGContextAddLineToPoint(ctx, kDisclosureStartX-kDisclosureRadius, kDisclosureStartY+kDisclosureRadius);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        CGContextSetLineWidth(ctx, kDisclosureWidth);
        
        if (self.highlighted)
        {
            [self.highlightedColor setStroke];
        }
        else
        {
            [self.accessoryColor setStroke];
        }
        
        CGContextStrokePath(ctx);
    }
    else if(_type == CHECKMARK)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctx, kCheckMarkStartX, kCheckMarkStartY);
        CGContextAddLineToPoint(ctx, kCheckMarkStartX + kCheckMarkLCGapX, kCheckMarkStartY + kCheckMarkLCGapY);
        CGContextAddLineToPoint(ctx, kCheckMarkStartX + kCheckMarkCRGapX, kCheckMarkStartY + kCheckMarkCRGapY);
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineWidth(ctx, kCheckMarkWidth);
        
        if (self.highlighted)
        {
            [self.highlightedColor setStroke];
        }
        else
        {
            [self.accessoryColor setStroke];
        }
        
        CGContextStrokePath(ctx);
    }
    else if(_type == TOGGLE_INDICATOR)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();

        if(self.selected)
        {
            CGContextMoveToPoint(   ctx, kToggleIndicatorStartX-kToggleIndicatorRadius, kToggleIndicatorStartY+kToggleIndicatorRadius);
            CGContextAddLineToPoint(ctx, kToggleIndicatorStartX,                   kToggleIndicatorStartY);
            CGContextAddLineToPoint(ctx, kToggleIndicatorStartX+kToggleIndicatorRadius, kToggleIndicatorStartY+kToggleIndicatorRadius);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            CGContextSetLineWidth(ctx, kToggleIndicatorLineWidth);
        }
        else
        {
            CGContextMoveToPoint(   ctx, kToggleIndicatorStartX-kToggleIndicatorRadius, kToggleIndicatorStartY);
            CGContextAddLineToPoint(ctx, kToggleIndicatorStartX,                   kToggleIndicatorStartY+kToggleIndicatorRadius);
            CGContextAddLineToPoint(ctx, kToggleIndicatorStartX+kToggleIndicatorRadius, kToggleIndicatorStartY);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            CGContextSetLineWidth(ctx, kToggleIndicatorLineWidth);
        }
        [self.accessoryColor setStroke];

        CGContextStrokePath(ctx);
    }
    else if(_type == FLAT_DETAIL_BUTTON)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIBezierPath *markCircle = [UIBezierPath bezierPathWithOvalInRect:FLAT_DETAIL_CIRCLE_RECT];

        CGContextSaveGState(ctx);
        {
            CGContextAddPath(ctx, markCircle.CGPath);
            CGContextSetLineWidth(ctx, FLAT_STROKE_WIDTH);
            CGContextSetStrokeColorWithColor(ctx, self.touchInside?_highlightedColor.CGColor:_accessoryColor.CGColor);
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
        }
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        {
            CGContextSetFillColorWithColor(ctx, self.touchInside?_highlightedColor.CGColor:_accessoryColor.CGColor);
            
            CGContextFillEllipseInRect(ctx, FLAT_DETAIL_BUTTON_DOT_FRAME);
            
            CGContextSetStrokeColorWithColor(ctx, self.touchInside?_highlightedColor.CGColor:_accessoryColor.CGColor);
            
            CGContextSetLineWidth(ctx, FLAT_DETAIL_BUTTON_VERTICAL_WIDTH);
            CGContextMoveToPoint(ctx, FLAT_DETAIL_BUTTON_VERTICAL_START_POINT.x, FLAT_DETAIL_BUTTON_VERTICAL_START_POINT.y);
            CGContextAddLineToPoint(ctx, FLAT_DETAIL_BUTTON_VERTICAL_END_POINT.x, FLAT_DETAIL_BUTTON_VERTICAL_END_POINT.y);
            CGContextStrokePath(ctx);

            CGFloat lineWidth = FLAT_DETAIL_BUTTON_HORIZONTAL_WIDTH;
            CGContextSetLineWidth(ctx, lineWidth);
            CGContextMoveToPoint(ctx, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_START_POINT.x, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_START_POINT.y);
            CGContextAddLineToPoint(ctx, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_END_POINT.x, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_END_POINT.y);
            
            CGContextMoveToPoint(ctx, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_START_POINT.x, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_START_POINT.y);
            CGContextAddLineToPoint(ctx, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_END_POINT.x, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_END_POINT.y);
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
    }
    else if(_type == FLAT_DISCLOSURE_INDICATOR)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctx, FLAT_DISCLOSURE_START_X-FLAT_DISCLOSURE_RADIUS, FLAT_DISCLOSURE_START_Y-FLAT_DISCLOSURE_RADIUS);
        CGContextAddLineToPoint(ctx, FLAT_DISCLOSURE_START_X, FLAT_DISCLOSURE_START_Y);
        CGContextAddLineToPoint(ctx, FLAT_DISCLOSURE_START_X-FLAT_DISCLOSURE_RADIUS, FLAT_DISCLOSURE_START_Y+FLAT_DISCLOSURE_RADIUS);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        CGContextSetLineWidth(ctx, FLAT_DISCLOSURE_WIDTH);
        
        if (self.highlighted)
        {
            [self.highlightedColor setStroke];
        }
        else
        {
            [self.accessoryColor setStroke];
        }
        
        CGContextStrokePath(ctx);

    }
    else if(_type == FLAT_DETAIL_DISCLOSURE)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIBezierPath *markCircle = [UIBezierPath bezierPathWithOvalInRect:FLAT_DETAIL_CIRCLE_RECT];
        
        UIColor *color1 = (UIColor *)_accessoryColors[0];
        UIColor *color2 = (UIColor *)_highlightedColors[0];
        UIColor *color3 = (UIColor *)_accessoryColors[1];
        UIColor *color4 = (UIColor *)_highlightedColors[1];
        
        CGContextSaveGState(ctx);
        {
            CGContextAddPath(ctx, markCircle.CGPath);
            CGContextSetLineWidth(ctx, FLAT_STROKE_WIDTH);
            CGContextSetStrokeColorWithColor(ctx, self.touchInside?color2.CGColor:color1.CGColor);
            CGContextDrawPath(ctx, kCGPathStroke);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
        }
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        {
            CGContextSetFillColorWithColor(ctx, self.touchInside?color2.CGColor:color1.CGColor);
            
            CGContextFillEllipseInRect(ctx, FLAT_DETAIL_BUTTON_DOT_FRAME);
            
            CGContextSetStrokeColorWithColor(ctx, self.touchInside?color2.CGColor:color1.CGColor);
            
            CGContextSetLineWidth(ctx, FLAT_DETAIL_BUTTON_VERTICAL_WIDTH);
            CGContextMoveToPoint(ctx, FLAT_DETAIL_BUTTON_VERTICAL_START_POINT.x, FLAT_DETAIL_BUTTON_VERTICAL_START_POINT.y);
            CGContextAddLineToPoint(ctx, FLAT_DETAIL_BUTTON_VERTICAL_END_POINT.x, FLAT_DETAIL_BUTTON_VERTICAL_END_POINT.y);
            CGContextStrokePath(ctx);
            
            CGFloat lineWidth = FLAT_DETAIL_BUTTON_HORIZONTAL_WIDTH;
            CGContextSetLineWidth(ctx, lineWidth);
            CGContextMoveToPoint(ctx, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_START_POINT.x, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_START_POINT.y);
            CGContextAddLineToPoint(ctx, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_END_POINT.x, FLAT_DETAIL_BUTTON_TOP_HORIZONTAL_END_POINT.y);
            
            CGContextMoveToPoint(ctx, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_START_POINT.x, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_START_POINT.y);
            CGContextAddLineToPoint(ctx, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_END_POINT.x, FLAT_DETAIL_BUTTON_BOTTOM_HORIZONTAL_END_POINT.y);
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
        
        CGContextSaveGState(ctx);
        {
            CGContextMoveToPoint(ctx, FLAT_DISCLOSURE_START_X-FLAT_DISCLOSURE_RADIUS, FLAT_DISCLOSURE_START_Y-FLAT_DISCLOSURE_RADIUS);
            CGContextAddLineToPoint(ctx, FLAT_DISCLOSURE_START_X, FLAT_DISCLOSURE_START_Y);
            CGContextAddLineToPoint(ctx, FLAT_DISCLOSURE_START_X-FLAT_DISCLOSURE_RADIUS, FLAT_DISCLOSURE_START_Y+FLAT_DISCLOSURE_RADIUS);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            CGContextSetLineWidth(ctx, FLAT_DISCLOSURE_WIDTH);
            
            if (self.highlighted)
            {
                [color4 setStroke];
            }
            else
            {
                [color3 setStroke];
            }
            CGContextStrokePath(ctx);
        }
        CGContextRestoreGState(ctx);
    }
    else if(_type == FLAT_CHECKMARK)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(ctx, FLAT_CHECKMARK_START_X, FLAT_CHECKMARK_START_Y);
        CGContextAddLineToPoint(ctx, FLAT_CHECKMARK_START_X + FLAT_CHECKMARK_LC_GAP_X, FLAT_CHECKMARK_START_Y + FLAT_CHECKMARK_LC_GAP_Y);
        CGContextMoveToPoint(ctx, FLAT_CHECKMARK_START_X + FLAT_CHECKMARK_LC_GAP_X + 0.5, FLAT_CHECKMARK_START_Y + FLAT_CHECKMARK_LC_GAP_Y);
        CGContextAddLineToPoint(ctx, FLAT_CHECKMARK_START_X + FLAT_CHECKMARK_CR_GAP_X, FLAT_CHECKMARK_START_Y + FLAT_CHECKMARK_CR_GAP_Y);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        CGContextSetLineWidth(ctx, FLAT_CHECKMARK_WIDTH);
        
        if (self.highlighted)
        {
            [self.highlightedColor setStroke];
        }
        else
        {
            [self.accessoryColor setStroke];
        }
        
        CGContextStrokePath(ctx);
    }
    else
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        if(self.selected)
        {
            CGContextMoveToPoint(   ctx, FLAT_TOGGLE_INDICATOR_START_X-FLAT_TOGGLE_INDICATOR_RADIUS, FLAT_TOGGLE_INDICATOR_START_Y+FLAT_TOGGLE_INDICATOR_RADIUS);
            CGContextAddLineToPoint(ctx, FLAT_TOGGLE_INDICATOR_START_X, FLAT_TOGGLE_INDICATOR_START_Y);
            CGContextAddLineToPoint(ctx, FLAT_TOGGLE_INDICATOR_START_X+FLAT_TOGGLE_INDICATOR_RADIUS, FLAT_TOGGLE_INDICATOR_START_Y+FLAT_TOGGLE_INDICATOR_RADIUS);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            CGContextSetLineWidth(ctx, FLAT_TOGGLE_INDICATOR_LINE_WIDTH);
        }
        else
        {
            CGContextMoveToPoint(   ctx, FLAT_TOGGLE_INDICATOR_START_X-FLAT_TOGGLE_INDICATOR_RADIUS, FLAT_TOGGLE_INDICATOR_START_Y);
            CGContextAddLineToPoint(ctx, FLAT_TOGGLE_INDICATOR_START_X, FLAT_TOGGLE_INDICATOR_START_Y+FLAT_TOGGLE_INDICATOR_RADIUS);
            CGContextAddLineToPoint(ctx, FLAT_TOGGLE_INDICATOR_START_X+FLAT_TOGGLE_INDICATOR_RADIUS, FLAT_TOGGLE_INDICATOR_START_Y);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineJoin(ctx, kCGLineJoinMiter);
            CGContextSetLineWidth(ctx, FLAT_TOGGLE_INDICATOR_LINE_WIDTH);
        }
        [self.accessoryColor setStroke];
        
        CGContextStrokePath(ctx);

    }
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
    
	[self setNeedsDisplay];
}

- (UIColor *)accessoryColor
{
	if (!_accessoryColor)
	{
		return [UIColor blackColor];
	}
    
	return _accessoryColor;
}

- (UIColor *)highlightedColor
{
	if (!_highlightedColor)
	{
		return [UIColor whiteColor];
	}
        
	return _highlightedColor;
}

@end
