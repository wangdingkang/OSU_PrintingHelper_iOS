//
//  DepartmentEnum.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/14/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

enum Department: String{
    
    case CSE = "Computer Science and Engineering"
    case ECE = "Electronic and Computer Engineering"
    
    static let allDepartments = [CSE, ECE]
    
    static func getIndexOfRawvalue(rawValue: String) -> Int {
        switch rawValue {
        case CSE.rawValue:
            return 0
        case ECE.rawValue:
            return 1
        default:
            break
        }
        return 0 
    }
    
}

//"CSE": ["lj_se_310_b", "lj_bo_118_a", "lj_cl_112_a", "lj_cl_112_b", "lj_cl_112_c", "lj_cl_413_a", "lj_dl_172_a", "lj_dl_272_a", "lj_dl_395_a", "ljc_dl_395_d","lj_dl_477_b", "lj_dl_577_a", "lj_dl_677_b","ljc_dl_677", "lj_dl_777_a", "lj_dl_894_a", "ljc_dl_894"],
//"ECE": ["CL260F", "DL517F", "DL557F", "DL817F"]
//[{"Location":"Baker Systems 310","Name":"lj_se_310_b","Type":"Black Laser"},{"Location":"Bolz Hall 117","Name":"lj_bo_118_a","Type":"Black Laser"},{"Location":"Caldwell Labs 112","Name":"lj_cl_112_a","Type":"Black Laser"},{"Location":"Caldwell Labs 112","Name":"lj_cl_112_b","Type":"Black Laser"},{"Location":"Caldwell Labs 112","Name":"lj_cl_112_c","Type":"Black Laser"},{"Location":"Caldwell Labs 413","Name":"lj_cl_413_a","Type":"Black Laser"},{"Location":"Dreese Labs 172","Name":"lj_dl_172_a","Type":"Black Laser"},{"Location":"Dreese Labs 272","Name":"lj_dl_272_a","Type":"Black Laser"},{"Location":"Dreese Labs 395Q","Name":"lj_dl_395_a","Type":"Black Laser"},{"Location":"Dreese Labs 395Q","Name":"ljc_dl_395_d","Type":"Color Laser"},{"Location":"Dreese Labs 477","Name":"lj_dl_477_b","Type":"Black Laser"},{"Location":"Dreese Labs 577","Name":"lj_dl_577_a","Type":"Black Laser"},{"Location":"Dreese Labs 677","Name":"lj_dl_677_b","Type":"Black Laser"},{"Location":"Dreese Labs 677","Name":"ljc_dl_677","Type":"Color Laser"},{"Location":"Dreese Labs 777","Name":"lj_dl_777_a","Type":"Black Laser"},{"Location":"Dreese Labs 895","Name":"lj_dl_894_a","Type":"Black Laser"},{"Location":"Dreese Labs 895","Name":"ljc_dl_894","Type":"Color Laser"},{"Location":"Caldwell Labs 260","Name":"CL260F","Type":"Black Printers"},{"Location":"Dreese Labs 517","Name":"DL517F","Type":"Black Printers"},{"Location":"Dreese Labs 557","Name":"DL557F","Type":"Black Printers"},{"Location":"Dreese Labs 817","Name":"DL817F","Type":"Black Printers"}]















