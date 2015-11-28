//
//  ComentViewController.h
//  Monk
//
//  Created by Abner Castro Aguilar on 28/11/15.
//  Copyright © 2015 Abner Castro Aguilar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentViewDelgate <NSObject>

- (void)didComment:(NSString *)comment;

@end

@interface ComentViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (retain)id <CommentViewDelgate> delegate;

@end
