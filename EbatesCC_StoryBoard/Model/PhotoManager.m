//
//  PhotoManager.m
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import "PhotoManager.h"
#import "RecentPhotoInfo.h"
#import "Constants.h"
#import "NetworkChecker.h"

#import "../ebates.pch"

@interface PhotoManager()

@property(nonatomic, strong) NSMutableDictionary<NSNumber*, RecentPhotoInfo*> *m_pImageStore;//for fast look up if we decide to cache on disk the photoinformation
@property(nonatomic, strong) NSMutableArray<RecentPhotoInfo*> *m_pIndexedPhotos;//for quick integration in uitableview


@end

@implementation PhotoManager
@synthesize m_pImageStore,m_pIndexedPhotos,m_pNetworkChecker;

+ (instancetype)sharedInstance
{
    static PhotoManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init])
    {
        self.m_pImageStore = [[NSMutableDictionary alloc] init];
        self.m_pIndexedPhotos = [[NSMutableArray alloc] init];
        self.m_pNetworkChecker = [[NetworkChecker alloc] init];
    }
    return self;
}

-(void) createNewPhoto:(nonnull NSMutableDictionary*)pResults
{
    RecentPhotoInfo *pNewPhoto = [[RecentPhotoInfo alloc] initPhotoInfoWithJSONData: pResults];
    [self addObject: pNewPhoto];
}

-(BOOL) removeObjectAtIndex:(NSInteger)index
{
    if( index >= self.m_pIndexedPhotos.count)
    {
        ErrorEbates(@"Index was out of bounds, not performing remove %ld", index);
        return NO;
    }
    
    RecentPhotoInfo *photoInfo = [self.m_pIndexedPhotos objectAtIndex: index];
    if( photoInfo)
    {
        NSNumber *key = [[NSNumber alloc] initWithLongLong: photoInfo.m_nID];
        [self.m_pIndexedPhotos removeObjectAtIndex: index];
        [self.m_pImageStore removeObjectForKey: key];
        return YES;
    }
    return NO;
}

-(void) addObject:(RecentPhotoInfo*)photoInfo
{
    NSNumber *key = [[NSNumber alloc] initWithLongLong: photoInfo.m_nID];
    if( !m_pImageStore[ key])
    {
        m_pImageStore[key] = photoInfo;
        [m_pIndexedPhotos addObject: photoInfo];
        //LogEbates(@" %@", photoInfo);
    }
    else
    {
        ErrorEbates(@"already inserted this object into dictionary %lld", photoInfo.m_nID);
    }
}

-(NSInteger) getNumPhotos
{
    if( m_pIndexedPhotos)
        return m_pIndexedPhotos.count;
    else
        return 0;
}

-(RecentPhotoInfo*)getPhotoAtIndex:(NSInteger)index
{
    return [m_pIndexedPhotos objectAtIndex: index];
}


-(void) flickrAPIGetRecentFlickrImages:(FlickrCallback)callback
{
    if( self.m_pNetworkChecker)
    {
        if( ![self.m_pNetworkChecker hasInternetConnection])
        {
            callback( NSLocalizedString(@"No Internet Connection, will not be able to reach FlickrAPI",nil));
            return;
        }
    }
    
    
    
    NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=fee10de350d1f31d5fec0eaf330d2dba&format=json&nojsoncallback=true";
    
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // NSURLSessionDataTask returns data, response, and error
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response,NSError *error)
                                      {
                                          [self reset];
                                          NSString *errorString = error.localizedDescription;
                                          if(error == nil)
                                          {
                                              //json results expected
                                              //photos[]->
                                              //page, pages, perpage, photo[]->farm,id,isfamily,isfriend,ispublic,owner,secret,server,title
                                              NSError *jsonError;
                                              NSMutableDictionary *flickrResultsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers
                                                  error:&jsonError];
                                              if( jsonError)
                                              {
                                                  ErrorEbates(@"error is %@\n", jsonError.localizedDescription);
                                                  errorString = jsonError.localizedDescription;
                                              }
                                              else if(!flickrResultsDict)
                                              {
                                                  errorString = NSLocalizedString(@"No Results","No Fetched Results From Flickr API");
                                              }
                                              else
                                              {
                                                  if( flickrResultsDict[@"code"])
                                                  {
                                                      errorString = [self getFlickrErrorFromCode: [flickrResultsDict[@"code"] integerValue]];
                                                  }
                                                  else
                                                  {
                                                      //LogEbates(@"flickr: %@", flickrResultsDict);
                                                      const NSMutableDictionary *pPhotosDict = flickrResultsDict[FLICKR_PHOTO_DICT_KEY];
                                                      if( pPhotosDict && pPhotosDict.count)
                                                      {
                                                          //grab the array of photo info now.
                                                          NSMutableArray *pPhotoArray = pPhotosDict[FLICKR_PHOTO_ARR_KEY];
                                                          for( NSMutableDictionary *results in pPhotoArray)
                                                          {
                                                              [self parseJSONFlickrPhotoInfo : results];
                                                          }
                                                      }
                                                      else
                                                      {
                                                      }
                                                  }
                                              }
                                          }
                                          
                                          callback(errorString);
                                      }];
    
    [dataTask resume];
}

-(NSString*)getFlickrErrorFromCode:(NSInteger)code
{
    switch( code)
    {
        case 1:   return NSLocalizedString(@"bad value for jump_to, must be valid photo id.",nil);
        case 100: return NSLocalizedString(@"Invalid API Key. The API key passed was not valid or has expired.",nil);
        case 105: return NSLocalizedString(@"Service currently unavailable. The requested service is temporarily unavailable.",nil);
        case 106: return NSLocalizedString(@"Write operation failed. The requested operation failed due to a temporary issue.",nil);
        case 111: return NSLocalizedString(@"Format xxx not found. The requested response format was not found.",nil);
        case 112: return NSLocalizedString(@"Method xxx not found. The requested method was not found.",nil);
        case 114: return NSLocalizedString(@"Invalid SOAP envelope.  The SOAP envelope send in the request could not be parsed.",nil);
        case 115: return NSLocalizedString(@"Invalid XML-RPC Method Call. The XML-RPC request document could not be parsed.",nil);
        case 116: return NSLocalizedString(@"Bad URL found. One or more arguments contained a URL that has been used for abuse on Flickr.",nil);
        default:
            return @"Unknown Error Code";
    }
}

-(void) parseJSONFlickrPhotoInfo:(nonnull NSMutableDictionary*)pResults
{
    [self createNewPhoto: pResults];
}

-(void) reset
{
    [self.m_pImageStore removeAllObjects];
    [self.m_pIndexedPhotos removeAllObjects];
}

@end
