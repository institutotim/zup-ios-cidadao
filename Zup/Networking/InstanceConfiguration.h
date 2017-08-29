#ifndef BASE_API_URL
    #ifdef BOA_VISTA
        #define BASE_API_URL @"http://api.boa-vista.zeladoriaurbana.com.br/"
        #define BASE_WEB_URL @"http://web.latest.staging.zup.ntxdev.com.br/"
    #elif defined(SBC)
        #define BASE_API_URL @"http://vcsbc.saobernardo.sp.gov.br:8081/"
        #define BASE_WEB_URL @"http://vcsbc.saobernardo.sp.gov.br/web/"
        #define TENANT @"sbc";
    #elif defined(SBC_SBC)
        #define BASE_API_URL @"http://vcsbc.saobernardo.sp.gov.br:8081/"
        #define BASE_WEB_URL @"http://web.latest.staging.zup.ntxdev.com.br/"
        #define TENANT @"sbc";
    #elif defined(FLORIPA)
        #define BASE_API_URL @"http://zup-api-florianopolis.cognita.ntxdev.com.br/"
        #define BASE_WEB_URL @"http://web.latest.staging.zup.ntxdev.com.br/"
    #elif defined(MACEIO)
        #define BASE_API_URL @"http://zup-api-maceio.cognita.ntxdev.com.br/"
        #define BASE_WEB_URL @"http://web.latest.staging.zup.ntxdev.com.br/"
    #else
        #define BASE_API_URL @"http://zup.conexaobrasil.org:8282/"
        #define BASE_WEB_URL @"http://zup.conexaobrasil.org:8282/"
        #define TENANT @"zup";
    #endif

    #define APIURL(x) BASE_API_URL x

    #if defined(SBC) || defined(SBC_SBC) || defined(SBC_NTX)
    static NSString * const kAPIkey = @"AIzaSyD8PQityBcZh_R2DkDXNW-qSjg4NpBhqdw";
    #elif defined(BOA_VISTA)
    static NSString * const kAPIkey = @"AIzaSyBolHDLHF5plSyxbz_ikP_R_0kWlpuU-uA";
    #else
    static NSString * const kAPIkey = @"AIzaSyBOHit7f4XSihOEtZpA8o_ysPo5ticplaA";
    #endif

    static NSString * const kClientId = @"937126404865.apps.googleusercontent.com";
    static NSString * const kClientSecret = @"By9p5DtVhQ-4AwDbHfcm5lbg";
#endif
