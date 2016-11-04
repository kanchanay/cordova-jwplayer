/********* CordovaJWPlayer.m Cordova Plugin Implementation *******/

#import "CordovaJWPlayer.h"

@implementation CordovaJWPlayer

- (void) pluginInitialize {
    self.defaultOptions = [[NSMutableDictionary alloc] init];
    self.defaultOptions[JWPOptionState.forceFullScreenOnLandscape] = [NSNumber numberWithBool:YES];
    self.defaultOptions[JWPOptionState.forceLandscapeOnFullScreen] = [NSNumber numberWithBool:YES];
    self.defaultOptions[JWPOptionState.onlyFullScreen]  = [NSNumber  numberWithBool:YES];
    self.defaultOptions[JWPOptionState.autostart]  = [NSNumber  numberWithBool:NO];
    self.defaultOptions[JWPOptionState.controls]  = [NSNumber  numberWithBool:YES];
    self.defaultOptions[JWPOptionState.repeat]  = [NSNumber  numberWithBool:NO];
    self.defaultOptions[JWPOptionState.image]  = [NSString  stringWithFormat:@""];
    self.defaultOptions[JWPOptionState.title]  = [NSString  stringWithFormat:@""];
    self.options = self.defaultOptions;
}


-(void)bindAction:(CDVInvokedUrlCommand*) command{
    NSString *event = [command.arguments objectAtIndex:0];
    if(command.callbackId.length > 0) {
        if([event isEqual: @"onPlay"]) {
            self.listenerOnPlayCallbackId = command.callbackId;
        }
        
        if([event isEqual: @"onPause"]) {
            self.listenerOnPauseCallbackId = command.callbackId;
        }
        
        if([event isEqual: @"onPlayerStateChange"]) {
            self.listenerOnPlayerStateChangeCallbackId = command.callbackId;
            [self setupNotifications];
        }
        
        if([event isEqual: @"onBeforePlay"]) {
            self.listenerOnBeforePlayCallbackId = command.callbackId;
        }
        
        if([event isEqual: @"onReady"]) {
            self.listenerOnReadyCallbackId = command.callbackId;
        }
        
        if([event isEqual: @"onComplete"]) {
            self.listenerOnCompleteCallbackId = command.callbackId;
        }
        
        if([event isEqual: @"onBeforeComplete"]) {
            self.listenerOnBeforeCompleteCallbackId = command.callbackId;
        }
        
        if([event isEqual: @"onIdle"]) {
            self.listenerOnIdleCallbackId = command.callbackId;
        }
        
        if([event isEqual: @"onFullscreen"]) {
            self.listenerOnFullscreenCallbackId = command.callbackId;
        }
        
    }

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setup:(CDVInvokedUrlCommand*)command
{
    
    NSDictionary *jsonOptions = [command.arguments objectAtIndex:0];
    NSLog(@" data %@", jsonOptions);
    
    if (![jsonOptions isKindOfClass:[NSNull class]] && [jsonOptions count] > 0) {
        for (id key in jsonOptions) {
            if ([self.options objectForKey:key] != nil) {
                [self.options setObject:jsonOptions[key] forKey:key];
            }
        }
    }
    [self createPlayer];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

- (void)setJWPlaylist:(CDVInvokedUrlCommand*)command
{
    NSArray *playList = [command.arguments objectAtIndex:0];
    [self initPlayList:playList];
    
    [self.player loadPlaylist:self.playlist];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)play:(CDVInvokedUrlCommand*)command
{
    NSNumber *index = [command.arguments objectAtIndex:0];
    [self.player setPlaylistIndex:[index integerValue]];
    NSLog(@" data %ld", (long)[self.player playlistIndex]);
    
    
    if(![self.player.view isDescendantOfView:self.viewController.view]) {
        [self.viewController.view addSubview:self.player.view];
    }
    
    NSNumber * attendingObject = [self.options objectForKey: JWPOptionState.onlyFullScreen];
    if(attendingObject) {
        [self.player enterFullScreen];
    } else {
        CGRect frame = self.viewController.view.bounds;
        frame.origin.y = 64;
        frame.size.height /= 2;
        frame.size.height -= 44 + 64;
        self.player.view.frame = frame;
        self.player.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    }

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) initPlayList: (NSArray *) plList
{
    NSMutableArray *pl = [NSMutableArray new];
    for (NSDictionary *playItem  in plList) {
        JWConfig *plConfig = [JWConfig new];
        NSMutableArray *sources = [NSMutableArray new];
        if(playItem[@"sources"]) {
            for(NSDictionary *source in playItem[@"sources"]) {
                if(source[@"isDefault"]) {
                    [sources addObject:[JWSource
                                    sourceWithFile: source[@"file"]
                                    label: source[@"label"]
                                    isDefault:source[@"isDefault"]]];
                } else {
                    [sources addObject:[JWSource
                                    sourceWithFile: source[@"file"]
                                    label: source[@"label"]]];
                }
            }
            
            plConfig.sources = sources;
        }
        

        plConfig.title = playItem[@"title"];
        JWPlaylistItem *JWp = [JWPlaylistItem playlistItemWithConfig:(JWConfig *) plConfig];
        
        if(playItem[@"mediaid"])
            JWp.mediaId = playItem[@"mediaid"];
       
        if(playItem[@"image"])
            JWp.image = playItem[@"image"];

        if(playItem[@"file"])
            JWp.file = playItem[@"file"];
        
        [pl addObject: JWp];
    }
    
    self.playlist = pl;
}

- (void)createPlayer
{
    self.currentSupportedOrientation =  [self.viewController valueForKey:@"supportedOrientations"];//[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedInterfaceOrientations"];
    JWConfig *config = [JWConfig new];
    config.image = self.options[JWPOptionState.image];
    config.title = self.options[JWPOptionState.title];
    
    config.controls = [self.options[JWPOptionState.controls] boolValue];
    config.repeat =  [self.options[JWPOptionState.repeat] boolValue];
    config.premiumSkin = JWPremiumSkinRoundster;
    config.autostart = [self.options[JWPOptionState.autostart] boolValue];
    
    NSLog(@" data %@", self.options[JWPOptionState.autostart]);
    
    if(!self.player) {
        self.player = [[JWPlayerController alloc] initWithConfig:config];
    }
    
    self.player.delegate = self;
  
    self.player.forceFullScreenOnLandscape = [self.options[JWPOptionState.forceFullScreenOnLandscape] boolValue];
    self.player.forceLandscapeOnFullScreen = [self.options[JWPOptionState.forceLandscapeOnFullScreen] boolValue];
}

-(void)onTime:(double)position ofDuration:(double)duration
{
    NSString *playbackPosition = [NSString stringWithFormat:@"%.01f/.01%f", position, duration];
    self.playbackTime.text = playbackPosition;
}

-(void)onPlay
{
    NSLog(@" data Start Playing");
    if(self.listenerOnPlayCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnPlayCallbackId];
    }
}

-(void)onPause
{
    NSLog(@" data Paused");
    if(self.listenerOnPauseCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnPauseCallbackId];
    }
}

-(void)onBuffer
{
    NSLog(@" data On Buffer");
}

-(void)onIdle
{
    NSLog(@" data on Idle");
    if(self.listenerOnIdleCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnIdleCallbackId];
    }
}

-(void)onReady
{
    NSLog(@" data onReady");
    if(self.listenerOnReadyCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnReadyCallbackId];
    }
}

-(void)onComplete
{
    NSLog(@" data onComplete");
    if(self.listenerOnCompleteCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnCompleteCallbackId];
    }
}

-(void)onAdSkipped:(NSString *)tag
{
    NSLog(@" data Slipping add");
}

-(void)onAdComplete:(NSString *)tag
{
    NSLog(@" data onAdComplete");
}

-(void)onAdImpression:(NSString *)tag
{
    NSLog(@" data onAdImpression");
}

- (void)onFullscreen:(BOOL)status
{
    NSLog(@" data Onfullscreen%c", status);
    NSNumber *onlyFullScreen = [self.options objectForKey: JWPOptionState.onlyFullScreen];
    
    if(onlyFullScreen) {
        if(status == NO) {
            [self.player stop];
            NSArray *orientations =  self.currentSupportedOrientation;
            [self.viewController setValue:orientations forKey:@"supportedOrientations"];
        } else {
            NSArray *orientations = @[[NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft], [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight]];
            [self.viewController setValue:orientations forKey:@"supportedOrientations"];
        }
    }
    
    NSLog(@" data Fullscreen");
    if(self.listenerOnFullscreenCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:status];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnPauseCallbackId];
    }
    
    
}

-(void)onBeforePlay
{
    NSLog(@" data onBeforePlay");

    if(self.listenerOnBeforePlayCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnBeforePlayCallbackId];
    }
}

-(void)onBeforeComplete
{
    NSLog(@" data onBeforeComplete");
    if(self.listenerOnBeforeCompleteCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnBeforeCompleteCallbackId];
    }
}

-(void)onAdPlay:(NSString *)tag
{
    NSLog(@" data onAdPlay");
}

-(void)onAdPause:(NSString *)tag
{
    NSLog(@" data onAdPause");
}

-(void)onAdError:(NSError *)error
{
    NSLog(@" data onAdError");
}

- (void)playerStateChanged:(NSNotification*)info
{
    NSDictionary *userInfo = info.userInfo;
    if(self.listenerOnPlayerStateChangeCallbackId.length > 0) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:userInfo];
        [pluginResult setKeepCallbackAsBool:true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.listenerOnPlayerStateChangeCallbackId];
    }
}

- (void)setupNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(playerStateChanged:) name:JWPlayerStateChangedNotification object:nil];
    [center addObserver:self selector:@selector(playerStateChanged:) name:JWAdActivityNotification object:nil];
}

@end