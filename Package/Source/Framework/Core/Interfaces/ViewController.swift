// ViewController.swift
// By Artem Golovanev

import Combine

protocol ViewController: AnyObject {
    associatedtype View: ContentView
    associatedtype Model: ViewModel
    where View.State == Model.State, View.Action == Model.Input
    
    var contentView: View { get }
    var viewModel: Model { get }
}
