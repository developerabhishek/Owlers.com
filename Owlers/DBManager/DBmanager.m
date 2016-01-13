//
//  DBmanager.m
//  Owlers
//
//  Created by Biprajit Biswas on 03/10/15.
//  Copyright (c) 2015 JNT. All rights reserved.
//

//#import "DBManager.h"
//
//static DBManager *_database;
//@implementation DBManager
//
//+(DBManager*)database
//{
//    if (_database == nil)
//    {
//        NSLog(@"DataBaseManagement database!");
//        _database=[[DBManager alloc]init];
//    }
//    return _database;
//}
//
//
//// Creates a writable copy of the bundled default database in the application Documents directory.
//- (void)createEditableCopyOfDatabaseIfNeeded
//{
//    NSLog(@"createEditableCopyOfDatabaseIfNeeded database!");
//    // First, test for existence.
//    BOOL success;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"documentsDirectory database!%@=",documentsDirectory);
//    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Survey_Submit.sqlite"];
//    success = [fileManager fileExistsAtPath:writableDBPath];
//    
//    if (success)
//        return;
//    // The writable database does not exist, so copy the default to the appropriate location.
//    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Survey_Submit.sqlite"];
//    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
//    
//    if (!success)
//    {
//        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
//    }
//}
//
//// Open the database connection and retrieve minimal information for all objects.
//- (void)initializeDatabase
//{
//    NSLog(@"initializeDatabase database!");
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    sqLiteDb= [documentsDirectory stringByAppendingPathComponent:@"Survey_Submit.sqlite"];
//    
//}
//
//- (id)init
//{
//    NSLog(@"init database!");
//    if ((self = [super init]))
//    {
//        
//        [self createEditableCopyOfDatabaseIfNeeded];
//        [self initializeDatabase];
//        
//        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK)
//        {
//            NSLog(@"Failed to open database!");
//        }
//    }
//    return self;
//}
//
//
////INSERT TABLE DATA
//-(void)insertRegData:(NSDictionary *)ques_dict answers:(NSArray *)ansArray
//{
//    
//    int statement_result;
//    const char *query = "insert into SurveyDetail (header, QuesText, Ans1, Ans2, Ans3, Ans4, Ans5, Ans6) values(?,?,?,?,?,?,?,?)";
//    sqlite3_stmt * insert_statement;
//    int prepare_result = sqlite3_prepare_v2(_database, query, -1, &insert_statement, NULL);
//    
//    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
//    {
//        sqlite3_close(_database);
//        return ;
//    }
//    
//    sqlite3_bind_text(insert_statement,1,[[ques_dict valueForKey:@"header"] UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,2,[[ques_dict valueForKey:@"description"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,3,[[[ansArray objectAtIndex:0] valueForKey:@"fld_optn_name"] UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,4,[[[ansArray objectAtIndex:1] valueForKey:@"fld_optn_name"] UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,5,[[[ansArray objectAtIndex:2] valueForKey:@"fld_optn_name"] UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,6,[[[ansArray objectAtIndex:3] valueForKey:@"fld_optn_name"] UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,7,[[[ansArray objectAtIndex:4] valueForKey:@"fld_optn_name"] UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,8,[[[ansArray objectAtIndex:5] valueForKey:@"fld_optn_name"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    statement_result = sqlite3_step(insert_statement);
//    
//    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
//    {
//        sqlite3_close(_database);
//        return ;
//    }
//    sqlite3_finalize(insert_statement);
//    
//}
//
//-(NSMutableDictionary *)getSurveyData:(int)row
//{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    
//    if (sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK)
//    {
//        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT *  FROM SurveyDetail where id = %d",row];
//        sqlite3_stmt *statement;
//        
//        if( sqlite3_prepare_v2(_database, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK )
//        {
//            //Loop through all the returned rows (should be just one)
//            while( sqlite3_step(statement) == SQLITE_ROW )
//            {
//                NSString *header = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
//                
//                NSString *question_Key = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
//                
//                NSString *ans_1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
//                
//                NSString *ans_2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
//                
//                NSString *ans_3 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
//                
//                NSString *ans_4 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
//                
//                NSString *ans_5 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
//                
//                NSString *ans_6 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
//                
//                // set question header and question text
//                [dict setValue:header forKey:@"header"];
//                [dict setValue:question_Key forKey:@"description"];
//                
//                
//                // set answers text
//                NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:ans_1,@"fld_optn_name", nil];
//                NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:ans_2,@"fld_optn_name", nil];
//                NSDictionary *dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:ans_3,@"fld_optn_name", nil];
//                NSDictionary *dict4 = [[NSDictionary alloc] initWithObjectsAndKeys:ans_4,@"fld_optn_name", nil];
//                NSDictionary *dict5 = [[NSDictionary alloc] initWithObjectsAndKeys:ans_5,@"fld_optn_name", nil];
//                NSDictionary *dict6 = [[NSDictionary alloc] initWithObjectsAndKeys:ans_6,@"fld_optn_name", nil];
//                
//                NSMutableArray *array = [NSMutableArray arrayWithObjects:dict1, dict2, dict3, dict4, dict5, dict6, nil];
//                
//                [dict setValue:array forKey:@"answer"];
//                
//            }
//        }
//        else
//        {
//            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_database) );
//        }
//        
//        // Finalize and close database.
//        sqlite3_finalize(statement);
//        // sqlite3_close(_database);
//    }
//    
//    return dict;
//}
//
//
//-(int)getDataBaseRowCount
//{
//    int count = 0;
//    if (sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK)
//    {
//        const char* sqlStatement = "SELECT COUNT(*) FROM SurveyDetail";
//        sqlite3_stmt *statement;
//        
//        if( sqlite3_prepare_v2(_database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
//        {
//            //Loop through all the returned rows (should be just one)
//            while( sqlite3_step(statement) == SQLITE_ROW )
//            {
//                count = sqlite3_column_int(statement, 0);
//            }
//        }
//        else
//        {
//            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_database) );
//        }
//        
//        // Finalize and close database.
//        sqlite3_finalize(statement);
//        // sqlite3_close(_database);
//    }
//    // sqlite3_close(_database);
//    
//    return count;
//}
//
//
//#pragma  mark - Insert Completed survey on localDataBase
//-(void)insertCompletedSurveyDataInLocaLDb:(NSDictionary *)survey_data  WithImage:(NSData *)surveyImage
//{
//    int statement_result;
//    const char *query = "insert into Completed_Survey (user_id, Ans_1, Ans_2, Ans_3, Ans_4, Ans_5, Ans_6, Ans_7, Ans_8, Ans_9, latitude, longitude, surveyImage, comment, DateTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
//    
//    //const char *query = "insert into Completed_Survey (user_id, Ans_1) values(?,?)";
//    sqlite3_stmt * insert_statement;
//    int prepare_result = sqlite3_prepare_v2(_database, query, -1, &insert_statement, NULL);
//    
//    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
//    {
//        sqlite3_close(_database);
//        return ;
//    }
//    
//    sqlite3_bind_text(insert_statement,1,[[survey_data valueForKey:@"user_id"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,2,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:0] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,3,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:1] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,4,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:2] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,5,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:3] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,6,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:4] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,7,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:5] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,8,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:6] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,9,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:7] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,10,[[[[survey_data valueForKey:@"questionlist"] objectAtIndex:8] valueForKey:@"rating"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    
//    sqlite3_bind_text(insert_statement,11,[[survey_data valueForKey:@"lat"] UTF8String], -1, SQLITE_TRANSIENT);
//    sqlite3_bind_text(insert_statement,12,[[survey_data valueForKey:@"lng"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    if (surveyImage.length > 0)
//    {
//        sqlite3_bind_blob(insert_statement, 13, [surveyImage bytes], (int)[surveyImage length], SQLITE_TRANSIENT);
//    }
//    
//    sqlite3_bind_text(insert_statement,14,[[survey_data valueForKey:@"comment"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insert_statement,15,[[survey_data valueForKey:@"currentTime"] UTF8String], -1, SQLITE_TRANSIENT);
//    
//    
//    statement_result = sqlite3_step(insert_statement);
//    
//    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
//    {
//        sqlite3_close(_database);
//        return ;
//    }
//    
//    sqlite3_finalize(insert_statement);
//}
//
//
//
//-(int)getDataBaseRowCountinCompletedSurvey
//{
//    int count = 0;
//    if (sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK)
//    {
//        const char* sqlStatement = "SELECT COUNT(*) FROM Completed_Survey";
//        sqlite3_stmt *statement;
//        
//        if( sqlite3_prepare_v2(_database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
//        {
//            //Loop through all the returned rows (should be just one)
//            while( sqlite3_step(statement) == SQLITE_ROW )
//            {
//                count = sqlite3_column_int(statement, 0);
//            }
//        }
//        else
//        {
//            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_database) );
//        }
//        
//        // Finalize and close database.
//        sqlite3_finalize(statement);
//        // sqlite3_close(_database);
//    }
//    // sqlite3_close(_database);
//    
//    return count;
//}
//
//-(NSMutableArray *)getCompltedSurveySavedData
//{
//    NSMutableArray *totalSavedSurvey = [[NSMutableArray alloc] init];
//    
//    if (sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK)
//    {
//        NSString *sqlStatement = [NSString stringWithFormat:@"SELECT *  FROM Completed_Survey"];
//        sqlite3_stmt *statement;
//        
//        if( sqlite3_prepare_v2(_database, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK )
//        {
//            //Loop through all the returned rows (should be just one)
//            while( sqlite3_step(statement) == SQLITE_ROW )
//            {
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];  // for every complete survey
//                
//                NSString *survey_id = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
//                [dict setValue:survey_id forKey:@"survey_id"];
//                
//                NSString *user_id = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
//                [dict setValue:user_id forKey:@"user_id"];
//                
//                NSString *lat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
//                [dict setValue:lat forKey:@"lat"];
//                
//                NSString *lon = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
//                [dict setValue:lon forKey:@"lng"];
//                
//                NSString *comment = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
//                [dict setValue:comment forKey:@"comment"];
//                
//                NSString *currentTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
//                [dict setValue:currentTime forKey:@"currentTime"];
//                
//                
//                
//                NSMutableArray *arr = [[NSMutableArray alloc]init];
//                for (int i=1; i <= 9; i++)
//                {
//                    NSMutableDictionary *quesDict = [[NSMutableDictionary alloc]init];
//                    NSString *ans = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i+1)];
//                    [quesDict setValue:ans forKey:@"rating"];
//                    [quesDict setValue:@"" forKey:@"answer_id"];
//                    [quesDict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"question_id"];
//                    
//                    [arr addObject:quesDict];
//                }
//                [dict setValue:arr forKey:@"answer"];
//                
//                
//                // Extract Image from DataBase
//                NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 13) length:sqlite3_column_bytes(statement, 13)];
//             //   UIImage *contImage = [UIImage imageWithData:data];
//               // [dict setValue:contImage forKey:@"survey_image"];
//                
//                [totalSavedSurvey addObject:dict];
//            }
//        }
//        else
//        {
//            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_database) );
//        }
//        
//        // Finalize and close database.
//        sqlite3_finalize(statement);
//        // sqlite3_close(_database);
//    }
//    
//    return totalSavedSurvey;
//}
//
//-(void)deleteSurveyFromLocalDataBase:(NSString *)surveyId
//{
//    if (sqlite3_open([sqLiteDb UTF8String], &_database) == SQLITE_OK)
//    {
//        //DELETE  FROM Completed_Survey where id = 5
//        
//        NSString *sqlStatement = [NSString stringWithFormat:@"DELETE  FROM Completed_Survey where id = %@",surveyId];
//        sqlite3_stmt *statement;
//        
//        if( sqlite3_prepare_v2(_database, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK )
//        {
//            //Loop through all the returned rows (should be just one)
//            if (sqlite3_step(statement) == SQLITE_DONE)
//            {
//                NSLog(@"Deleted");
//            }
//            else
//            {
//                NSLog(@"Not Deleted");
//            }
//            
//        }
//        else
//        {
//            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_database) );
//        }
//        
//        // Finalize and close database.
//        sqlite3_finalize(statement);
//        sqlite3_close(_database);
//    }
//    // sqlite3_close(_database);
//    
//}
//
//@end
