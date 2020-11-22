//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLNodeID.h"
#import "OWLCowlUtils.h"

#import <cowl_node_id.h>

OWLNodeID OWLNodeID_new(void) {
    CowlNodeID nodeId = cowl_node_id_get_unique();
    
    if (nodeId == COWL_NODE_ID_NULL) {
        NSString *reason = @"Exceeded the maximum number of anonymous node identifiers.";
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:reason
                                     userInfo:nil];
    }

    return nodeId;
}

NSString * OWLNodeID_toString(OWLNodeID nodeId) {
    return stringFromCowl(cowl_node_id_to_string((CowlNodeID)nodeId), YES);
}
