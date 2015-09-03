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

enum FileType: String{
    case JPG = "icon_jpg"
    case PNG = "icon_png"
    case PDF = "icon_pdf"
    case DOC = "icon_doc"
    case DOCX = "icon_docx"
    case UNKNOWN = "icon_unknown"
}


// "beta.cse.ohio-state.edu", "epsilon.cse.ohio-state.edu", "gamma.cse.ohio-state.edu", "zeta.cse.ohio-state.edu"
enum CSEHost: String {
    
    case BETA = "beta.cse.ohio-state.edu"
    case EPSILON = "epsilon.cse.ohio-state.edu"
    case GAMMA = "gamma.cse.ohio-state.edu"
    case ZETA = "zeta.cse.ohio-state.edu"
    
    static let allHosts = [BETA, EPSILON, GAMMA, ZETA]
    
}

enum ECEHost: String {
    case RH001 = "rh001.ece.ohio-state.edu"
    case RH002 = "rh002.ece.ohio-state.edu"
    case RH003 = "rh003.ece.ohio-state.edu"
    case RH004 = "rh004.ece.ohio-state.edu"
    case RH005 = "rh005.ece.ohio-state.edu"
    case RH006 = "rh006.ece.ohio-state.edu"
    case RH007 = "rh007.ece.ohio-state.edu"
    case RH008 = "rh008.ece.ohio-state.edu"
    case RH009 = "rh009.ece.ohio-state.edu"
    case RH010 = "rh010.ece.ohio-state.edu"
    case RH011 = "rh011.ece.ohio-state.edu"
    case RH012 = "rh012.ece.ohio-state.edu"
    case RH013 = "rh013.ece.ohio-state.edu"
    case RH014 = "rh014.ece.ohio-state.edu"
    case RH015 = "rh015.ece.ohio-state.edu"
    case RH016 = "rh016.ece.ohio-state.edu"
    case RH017 = "rh017.ece.ohio-state.edu"
    case RH018 = "rh018.ece.ohio-state.edu"
    case RH019 = "rh019.ece.ohio-state.edu"
    case RH020 = "rh020.ece.ohio-state.edu"
    case RH021 = "rh021.ece.ohio-state.edu"
    case RH022 = "rh022.ece.ohio-state.edu"
    case RH023 = "rh023.ece.ohio-state.edu"
    case RH024 = "rh024.ece.ohio-state.edu"
    case RH025 = "rh025.ece.ohio-state.edu"
    case RH026 = "rh026.ece.ohio-state.edu"
    
    static let allHosts = [ RH001, RH002, RH003, RH004, RH005, RH006, RH007, RH008, RH009, RH010, RH011, RH012, RH013, RH014, RH015, RH016, RH017, RH018, RH019, RH020, RH021, RH022, RH023, RH024, RH025, RH026
    ]
    
}



//"CSE": ["lj_se_310_b", "lj_bo_118_a", "lj_cl_112_a", "lj_cl_112_b", "lj_cl_112_c", "lj_cl_413_a", "lj_dl_172_a", "lj_dl_272_a", "lj_dl_395_a", "ljc_dl_395_d","lj_dl_477_b", "lj_dl_577_a", "lj_dl_677_b","ljc_dl_677", "lj_dl_777_a", "lj_dl_894_a", "ljc_dl_894"],
//"ECE": ["CL260F", "DL517F", "DL557F", "DL817F"]
//[{"Location":"Baker Systems 310","Name":"lj_se_310_b","Type":"Black Laser"},{"Location":"Bolz Hall 117","Name":"lj_bo_118_a","Type":"Black Laser"},{"Location":"Caldwell Labs 112","Name":"lj_cl_112_a","Type":"Black Laser"},{"Location":"Caldwell Labs 112","Name":"lj_cl_112_b","Type":"Black Laser"},{"Location":"Caldwell Labs 112","Name":"lj_cl_112_c","Type":"Black Laser"},{"Location":"Caldwell Labs 413","Name":"lj_cl_413_a","Type":"Black Laser"},{"Location":"Dreese Labs 172","Name":"lj_dl_172_a","Type":"Black Laser"},{"Location":"Dreese Labs 272","Name":"lj_dl_272_a","Type":"Black Laser"},{"Location":"Dreese Labs 395Q","Name":"lj_dl_395_a","Type":"Black Laser"},{"Location":"Dreese Labs 395Q","Name":"ljc_dl_395_d","Type":"Color Laser"},{"Location":"Dreese Labs 477","Name":"lj_dl_477_b","Type":"Black Laser"},{"Location":"Dreese Labs 577","Name":"lj_dl_577_a","Type":"Black Laser"},{"Location":"Dreese Labs 677","Name":"lj_dl_677_b","Type":"Black Laser"},{"Location":"Dreese Labs 677","Name":"ljc_dl_677","Type":"Color Laser"},{"Location":"Dreese Labs 777","Name":"lj_dl_777_a","Type":"Black Laser"},{"Location":"Dreese Labs 895","Name":"lj_dl_894_a","Type":"Black Laser"},{"Location":"Dreese Labs 895","Name":"ljc_dl_894","Type":"Color Laser"},{"Location":"Caldwell Labs 260","Name":"CL260F","Type":"Black Printers"},{"Location":"Dreese Labs 517","Name":"DL517F","Type":"Black Printers"},{"Location":"Dreese Labs 557","Name":"DL557F","Type":"Black Printers"},{"Location":"Dreese Labs 817","Name":"DL817F","Type":"Black Printers"}]















