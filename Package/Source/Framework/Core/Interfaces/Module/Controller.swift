// Controller.swift
// By Artem Golovanev

import Combine
import Foundation

@MainActor
public protocol Controller: AnyObject {
    associatedtype View: ContentView
    associatedtype Model: ViewModel
    where View.Adapter.State == Model.Item, View.Adapter.Item == Model.Input
    
    var contentView: View { get }
    var viewModel: Model { get }
}

public extension Controller {
    func bind() -> Set<AnyCancellable> {
        return [
            viewModel
                .publisher
                .receive(on: DispatchQueue.main)
                .sink { [adapter = contentView.adapter] in
                    adapter.update(with: $0)
                },
            contentView
                .adapter
                .publisher
                .sink { [viewModel] in
                    viewModel.send($0)
                }
        ]
    }
}
