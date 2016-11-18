

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject {

@private
    NSString *_password;
    NSString *_login;
}

@property(strong) NSString *login;
@property(strong) NSString *password;

@end
