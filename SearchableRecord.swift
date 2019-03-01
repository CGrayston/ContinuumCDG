//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Chris Grayston on 2/15/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation

protocol SearchableRecord {
  func matches(searchTerm: String) -> Bool
}
