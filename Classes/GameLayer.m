//
//  HelloWorldLayer.m
//  novaRPG
//
//  Created by nova on 01.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"

// HelloWorld implementation
@implementation GameLayer

+(id) gameplayScene
{
	// 'scene' is an autorelease object.
	CCScene *gameplayScene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *gameLayer = [GameLayer node];
	
	// add layer as a child to scene
	[gameplayScene addChild: gameLayer];
	
	// return the scene
	return gameplayScene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init] )) {
		// Load Tilemap
		_tileMap = [[MapModel alloc] loadMap:@"testMap2"];
		[self addChild:_tileMap.tileMap];
		[_tileMap.fgLayer setVertexZ:3.0f];
		
		// Load Playersprite
		_playerChar = [[CharacterModel alloc] loadSprite:@"playersprite_female" onMap:_tileMap];
		_playerChar.characterSprite.position = [_tileMap spawnPoint];
		[self addChild:_playerChar.spriteSheet];
		[_playerChar.spriteSheet setVertexZ:1.0f];
		
		// Center camera on SpawnPoint
		[self centerCamera:[_tileMap spawnPoint]];
		
		//Enable Touch Support
		self.isTouchEnabled = YES;
		
		// Initializing the virtual D-Pad
		_dDown1 = CGRectMake(0, 0, 200, 90);
		_dDown2 = CGRectMake(280, 0, 200, 90);
		_dUp1 = CGRectMake(0, 230, 200, 90);
		_dUp2 = CGRectMake(280, 230, 200, 90);
		_dLeft = CGRectMake(0, 90, 240, 140);
		_dRight = CGRectMake(240, 90, 240, 140);
		
		_dTop = CGRectMake(200, 230, 80, 90);
		_dBot = CGRectMake(200, 0, 80, 90);
		
		_loopSpeed = 0;
		
		CCLOG(@"%i",[_tileMap.npcs count]);
		
		_npcarray = [[NSMutableArray alloc] init];
		
		//Load NPCs on Map
		for (int i = 0;i < [_tileMap.npcs count]; i = i+1) {
			CCLOG(@"Loading NPC with display id %@",[[_tileMap.npcs objectAtIndex:i] valueForKey:@"displayid"]);
			CharacterModel *npc = [CharacterModel alloc];
			[npc loadSprite:[[_tileMap.npcs objectAtIndex:i] valueForKey:@"displayid"] onMap:_tileMap];
			npc.characterSprite.position = [_tileMap npcSpawnForId:i];
			[self addChild:npc.spriteSheet];
			[_npcarray addObject:npc];
		}
		
		// Start the GameLoop
		[self schedule:@selector(gameLoop:) interval: _loopSpeed];
		[self runAction:[CCFollow actionWithTarget:_playerChar.characterSprite]];
	}
	return self;
}

// Camera actions go here
-(void) centerCamera:(CGPoint) point {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(-point.x+winSize.width/2,-point.y+winSize.height/2);
}

-(void) moveCameraByTile:(CGPoint)point withDuration:(int) duration {
	[self runAction:[CCMoveBy actionWithDuration:duration position:ccp(_tileMap.tileMap.tileSize.width*-point.x,_tileMap.tileMap.tileSize.height*-point.y)]];
}

-(void) moveCameraToPos:(CGPoint)point withDuration:(int) duration {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[self runAction:[CCMoveTo actionWithDuration:duration position:ccp(-point.x+winSize.width/2,-point.y+winSize.height/2)]];
}

// Touch Handling methods start here
// Set up Touch Dispatcher
-(void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Actual Touch Handling happens here
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
		if (CGRectContainsPoint(_dDown1, touchLocation) || CGRectContainsPoint(_dDown2, touchLocation)) {
			_playerChar.moveState = 1;
		}
		
		if (CGRectContainsPoint(_dUp1, touchLocation) || CGRectContainsPoint(_dUp2, touchLocation)) {
			_playerChar.moveState = 2;
		}
		
		if (CGRectContainsPoint(_dLeft, touchLocation)) {
			_playerChar.moveState = 3;
		}
		
		if (CGRectContainsPoint(_dRight, touchLocation)) {
			_playerChar.moveState = 4;
		}
	
	if (CGRectContainsPoint(_dTop, touchLocation)) {
		CCLOG(@"D-Pad Top");
		int actions = [_playerChar.characterSprite numberOfRunningActions];
		CCLOG(@"%i",actions);
	}
	
	if (CGRectContainsPoint(_dBot, touchLocation)) {
		CCLOG(@"D-Pad Bot");
	}

	
	// Return YES to bind the Touch to self
	return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
		if (CGRectContainsPoint(_dDown1, touchLocation) || CGRectContainsPoint(_dDown2, touchLocation)) {
			_playerChar.moveState = 1;
		}
		
		if (CGRectContainsPoint(_dUp1, touchLocation) || CGRectContainsPoint(_dUp2, touchLocation)) {
			_playerChar.moveState = 2;
		}
		
		if (CGRectContainsPoint(_dLeft, touchLocation)) {
			_playerChar.moveState = 3;
		}
		
		if (CGRectContainsPoint(_dRight, touchLocation)) {
			_playerChar.moveState = 4;
		}
	
	
	if (CGRectContainsPoint(_dTop, touchLocation)) {
		NSLog(@"D-Pad Top");
	}
	
	if (CGRectContainsPoint(_dBot, touchLocation)) {
		NSLog(@"D-Pad Bot");
	}}

// Stop all Movement on TouchEnded
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	_playerChar.moveState = 0;
}

// Gameloop and loop method start here
-(void) gameLoop:(ccTime) dt {
	if ([_playerChar.characterSprite numberOfRunningActions] == 0 || _playerChar.moveState == 0) {
		[_playerChar update];
	}
}



- (void) dealloc
{
	_tileMap = nil;
	_playerChar = nil;
	[super dealloc];
}
@end
