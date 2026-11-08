// ContentCell.swift
// By Artem Golovanev

import Foundation

@MainActor
public protocol ContentCell: AnyObject {
    associatedtype Item
    
    func update(with item: Item)
}
