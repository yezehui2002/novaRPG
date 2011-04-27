//
//  HelloWorldLayer.h
//  novaRPG
//
//  Created by nova on 01.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "MapModel.h"
#import "CharacterModel.h"

// HelloWorld Layer
@interface GameLayer : CCLayer
{
	MapModel *_tileMap;
	CharacterModel *_playerChar;
	
	CGRect _dDown1;
	CGRect _dDown2;
	CGRect _dUp1;
	CGRect _dUp2;
	CGRect _dLeft;
	CGRect _dRight;
	
	CGRect _dTop;
	CGRect _dBot;
	
	float _loopSpeed;
	
	NSMutableArray *_npcarray;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) gameplayScene;
-(void) centerCamera:(CGPoint)point;
-(void) moveCameraByTile:(CGPoint)point withDuration:(int) duration;
-(void) moveCameraToPos:(CGPoint)point withDuration:(int) duration;
-(void) gameLoop: (ccTime) dt;

@end
