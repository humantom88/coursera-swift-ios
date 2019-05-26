//
//  ViewOutput.swift
//  Filters
//
//  Created by Tom Belov on 25/05/2019.
//  Copyright © 2019 Tom Belov. All rights reserved.
//

import UIKit

protocol ViewOutput {
    var processor: Processor? { get set }
    var filtersState: FiltersState { get set }
    
    func updateImageFilters()
}
